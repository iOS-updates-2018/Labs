OBJECTIVES
===
- Teach students about using WebKit framework
- Have students interact with URL and related classes
- Have students practice implementing methods from iOS delegates
- Reinforce previous iOS development lessons
- Refresh student knowledge of linked lists
- Give students practice with programming and testing in Swift


CONTENTS
===
Part 1: SimpleBrowser (iOS app)
---

In this lab we will use WebKit to help us build our own browser for the iPhone.  It's a scaled down browser, but it should have a navigation bar so we can enter in URLs, have both a reload and a stop button, and have a set of back and forward buttons for simple navigation.  Below is a screenshot of what this app will look like when finished:

  ![Final Product](https://i.imgur.com/X3xoC8J.jpg)

1. Start a new project called 'SimpleBrowser' as a single page application. Once this is created, go to the main storyboard and drag in a navigation controller.  Keep the navigation controller but remove the root view controller completely. Right-click (press control first) on the navigation view controller and drag to the view controller; choose the root view controller. 

2. Click on the navigation view controller, go to the attributes inspector and click on bar visibility, `Shows Toolbar`.  This will allow the toolbar at the bottom of the view controller storyboard to appear and for us to drag items over to it. Also, click the 'is initial view controller' option.

    ![Navigation Controller](https://i.imgur.com/rKs3qEE.png)

3. There are some [SimpleBrowser icons](http://67442.cmuis.net/files/67442/simple_browser_icons.zip) you can use or you are free to create your own.  The site [MakeAppicon](https://makeappicon.com/) is really nice for taking png, jpg and psd files and turning them into Appicons that can be easily integrated into our app (as we did in the first two labs).

4. In the top nav bar, drag over a bar button item over to the right and set it to custom with the word 'Go'. After that, drag a text field into the middle of the nav bar and expand its size so that it takes up most of the remaining space (with a small buffer between the button, of course).  Make an outlet for the text field called `locationField` in the view controller and make sure it is properly connected. (You know the drill.)

5. In the toolbar at the bottom, drag over 5 bar button items and 4 fixed space bar items. Give the first a title of `<`. Convert the second a title of `>`. The third should be the system item `Action`, the fourth `Refresh` and then the last to `Stop`. Note that you can manually adjust the fixed space bar button (experiment by expanding and contracting until it's the size you want; mine is very minimal in width). For each of the buttons make an outlet with an appropriate name.

6. Now we want to work with the view itself. We want the entire view (minus the nav bars) to be the web view in this case.  To do this, we start off by creating a web view object to work with. Drag into your storyboard a WebKit View.

    ![Buttons](https://i.imgur.com/O95Yu6w.png)

7. Now we are going to override the method `viewDidAppear()`. You will need to create this method yourself. Let's start by adding in a call to its super method. Following that we want to create a swift URL using the following code:
  ```swift
        let urlString:String = "https://www.apple.com" // default page
        let url:URL = URL(string: urlString)!
  ``` 

8. The urlString will be the default page for your browser. (Choose your favorite site if you'd like; doesn't really matter.) The [URLRequest](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURLRequest_Class/) object handles loading the resource from the URL we specified. Of course, the [URL](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSURL_Class/) object helps us construct proper URLs but doesn't actually load them into the web view; to do that we add the following code:
  ```swift
        let urlRequest:URLRequest = URLRequest(url: url)
        webView.load(urlRequest)
  ```

9. There is just one more change we want to make to `viewDidAppear()`. We want the text box at the top of the page to be set to the initial URl that we provided. Set the ```.text``` attribute of the text box object equal to the URL string. 

Now build your project and you should see the default web page and the text box should display the correct URL.

10. The problem with the app right now is that if you change the URL and click `Go`, nothing happens. To correct this we need to add some actions for our buttons.  The first will be to make the `Go` button go somewhere:
  ```swift
  @IBAction func goTapped(_ sender: Any) {
    let url = URL(string: "https://" + locationField!.text)!
    webView.loadRequest(URLRequest(URL: url))
  }
  ```

  In this case we will append the https:// for the user and then load the new request.  Connect the button to this action, rebuild the app and see that it now works.

11. We also need actions for back, forward, refresh and stop, luckily the `webView` object we created earlier makes this super easy with built-in methods for us to use.  Add to the view controller the following code:
  ```swift
  @IBAction func refreshTapped(_ sender: Any) {
    webView.reload()
  }

  @IBAction func backTapped(_ sender: Any) {
    if webView.canGoBack {
      webView.goBack()
    }
  }
  
  @IBAction func forwardTapped(_ sender: Any) {
    if webView.canGoForward {
      webView.goForward()
    }
  }

  @IBAction func stopTapped(_ sender: Any) {
    webView.stopLoading()
  }
  ```

  Wire these buttons up to their actions, rebuild and verify the app is working properly.

12. Now this seems great, but what if the user adds an inappropriate URL, like 'george'. We need to tell the user this is not acceptable.  We've used alerts in past projects so we can easily add one here.  We will take advantage of the [WKNavigationDelegate](https://developer.apple.com/library/prerelease/ios/documentation/WebKit/Reference/WKNavigationDelegate_Ref/index.html) protocol to help us. Looking over the documentation, we see there is a webView method `didFail:withError` that seems to be exactly what we need.  We can implement that method and get it to add in our alert message: 

```swift
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
    }
  ```

  If we build it again and run it, we see it works when we type in 'george' in the location field, but after dismissing the alert the invalid URL still appears with the old page and that could be confusing. To fix this, add some code to the method above so that it clears the location field and resets the focus to that field to accept user input right away.  Do this and rebuild to verify the app is working.

13. We have a pretty nice browser, but one thing seems a little clunky about it (okay, probably several) that we want to fix.  After entering a new URL the user presses enter and expects to go to that page, but that won't happen until we move the cursor over and hit `Go`. We can make the browser reload upon hitting enter in the location field by taking advantage of the [UITextFieldDelegate](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITextFieldDelegate_Protocol/) that we also worked with in lab 2. Review those instructions and apply those ideas to this lab as well.  Once the the view controller adopts the `UITextFieldDelegate` protocol we have to let the location field know that by control-clicking on the location field and dragging over to the view controller; in the popup window choose `Outlet -delegate`.  Finally, implement the method from the `UITextFieldDelegate` protocol:
  ```swift
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let urlString:String = locationField.text!
        let url:URL = URL(string: urlString)!
        let urlRequest:URLRequest = URLRequest(url: url)
        
        webView.load(urlRequest)

        locationField.resignFirstResponder()
        return true
    }
  ```

  Picking some nits here, we notice that the middle two lines are a repeat from the code in `viewDidLoad()`. Let's refactor this into a new method `goToPage()` and make both `viewDidLoad()` and `textFieldShouldReturn()` utilize this new method.

14. It would be nice if the user could see when the back button and forward buttons would actually take them somewhere. We can add the following method to set the backButton and forwardButton as enabled.
  ```swift
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        backButton.isEnabled = webView.canGoBack
        // [Add Code for Forward Button]
        
        locationField.text = webView.url?.absoluteString
    }
  ```

15. Now we just have the Share button left. Apple makes sharing very easy for the developer to incorporate into their applications. The UIActivityViewController will take care of almost everything if you build it the proper way. 
  ```swift    
     @IBAction func shareButtonTapped(_ sender: Any) {
        let urlString:String = locationField.text!
        let url:URL = URL(string: urlString)!
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        navigationController?.present(activityViewController, animated: true)
    }
  ```

There is much more you might choose to do with this app to really build out the browser now, but we have a basic functioning web browser for our mobile devices. There is a lot of more power in WebKit and in various iOS delegates that we can utilize on our own later. If you choose to experiment more (a great idea) I suggest doing so on a new branch so you can revert back easily if things go awry.  Time now, however, to do some functional programming exercises.

Part 2: Linked Lists (Swift)
---



#### Building a linked list

We will begin building our linked list structure in a playground and then later move this to a more formal project that we can test using XCTest.  Opening up a playground, we'll start by defining a type to describe the nodes:
  ```swift
public class LinkedListNode<T> {
  var value: T
  var next: LinkedListNode?
  weak var previous: LinkedListNode?

  public init(value: T) {
    self.value = value
  }
}
  ```

This is a generic type, so `T` can be any kind of data that you'd like to store in the node. We'll be using strings in the examples that follow.

Ours is a doubly-linked list and each node has a `next` and `previous` pointer. These can be `nil` if there are no next or previous nodes, so these variables must be optionals. (In what follows, I'll point out which functions would need to change if this was just a singly- instead of a doubly-linked list.)

> **Note:** To avoid ownership cycles, we declare the `previous` pointer to be weak. If you have a node `A` that is followed by node `B` in the list, then `A` points to `B` but also `B` points to `A`. In certain circumstances, this ownership cycle can cause nodes to be kept alive even after you deleted them. We don't want that, so we make one of the pointers `weak` to break the cycle.

Let's start building `LinkedList`. Here's the first bit:
  ```swift
public class LinkedList<T> {
  public typealias Node = LinkedListNode<T>

  private var head: Node?
  
  public var isEmpty: Bool {
    return head == nil
  }
  
  public var first: Node? {
    return head
  }
}
  ```

Ideally, I'd like to put the `LinkedListNode` class inside `LinkedList` but Swift currently doesn't allow generic types to have nested types. Instead we're using a typealias so inside `LinkedList` we can write the shorter `Node` instead of `LinkedListNode<T>`.

This linked list only has a `head` pointer, not a tail. Adding a tail pointer is left as an exercise for the reader. (I'll point out which functions would be different if we also had a tail pointer.)

The list is empty if `head` is nil. Because `head` is a private variable, I've added the property `first` to return a reference to the first node in the list.

You can try it out in a playground like this:
  ```swift
let list = LinkedList<String>()
list.isEmpty   // true
list.first     // nil
  ```

Let's also add a property that gives you the last node in the list. This is where it starts to become interesting:
  ```swift
  public var last: Node? {
    if var node = head {
      while case let next? = node.next {
        node = next
      }
      return node
    } else {
      return nil
    }
  }
  ```

In class we talked about `if let` but not `if var`. It does the same thing -- it unwraps the `head` optional and puts the result in a new local variable named `node`. The difference is that `node` is not a constant but an actual variable, so we can change it inside the loop.

The loop also does some Swift magic. The `while case let next? = node.next` bit keeps looping until `node.next` is nil. Making use of Swift's built-in support for unwrapping optionals, we'll use these kinds of loops again in the code that follows.

> **Note:** If we kept a tail pointer, `last` would simply do `return tail`. But we don't, so it has to step through the entire list from beginning to the end. It's an expensive operation, especially if the list is long.

Of course, `last` only returns nil because we don't have any nodes in the list. Let's add a method that adds a new node to the end of the list:
  ```swift
  public func append(value: T) {
    let newNode = Node(value: value)
    if let lastNode = last {
      newNode.previous = lastNode
      lastNode.next = newNode
    } else {
      head = newNode
    }
  }
  ```

The `append()` method first creates a new `Node` object and then asks for the last node using the `last` property we've just added. If there is no such node, the list is still empty and we make `head` point to this new `Node`. But if we did find a valid node object, we connect the `next` and `previous` pointers to link this new node into the chain. A lot of linked list code involves this kind of `next` and `previous` pointer manipulation.

Let's test it in the playground:
  ```swift
list.append(value:"Hello")
list.isEmpty         // false
list.first!.value    // "Hello"
list.last!.value     // "Hello"
  ```

The list looks like this:

	         +---------+
	head --->|         |---> nil
	         | "Hello" |
	 nil <---|         |
	         +---------+

Now add a second node:
  ```swift
list.append(value:"World")
list.first!.value    // "Hello"
list.last!.value     // "World"
  ```

And the list looks like:

	         +---------+    +---------+
	head --->|         |--->|         |---> nil
	         | "Hello" |    | "World" |
	 nil <---|         |<---|         |
	         +---------+    +---------+

You can verify this for yourself by looking at the `next` and `previous` pointers:
  ```swift
list.first!.previous          // nil
list.first!.next!.value       // "World"
list.last!.previous!.value    // "Hello"
list.last!.next               // nil
  ```

Let's add a method to count how many nodes are in the list. This will look very similar to what we did already:
  ```swift
  public var count: Int {
    if var node = head {
      var c = 1
      while case let next? = node.next {
        node = next
        c += 1
      }
      return c
    } else {
      return 0
    }
  }
  ```

It loops through the list in the same manner but this time increments a counter as well.

> **Note:** One way to speed up `count` from **O(n)** to **O(1)** is to keep track of a variable that counts how many nodes are in the list. Whenever you add or remove a node, you also update this variable.

What if we wanted to find the node at a specific index in the list? With an array we can just write `array[index]` and it's an **O(1)** operation. It's a bit more involved with linked lists, but again the code follows a similar pattern:
  ```swift
  public func nodeAtIndex(index: Int) -> Node? {
    if index >= 0 {
      var node = head
      var i = index
      while node != nil {
        if i == 0 { return node }
        i -= 1
        node = node!.next
      }
    }
    return nil
  }
  ```

The loop looks a little different but it does the same thing: it starts at `head` and then keeps following the `node.next` pointers to step through the list. We're done when we've seen `index` nodes, i.e. when the counter has reached 0.

Try it out:
  ```swift
list.nodeAtIndex(index:0)!.value    // "Hello"
list.nodeAtIndex(index:1)!.value    // "World"
list.nodeAtIndex(index:2)           // nil
  ```

For fun we can implement a `subscript` method too:
  ```swift
  public subscript(index: Int) -> T {
    let node = nodeAtIndex(index: index)
    assert(node != nil)
    return node!.value
  }
  ```

Now you can write the following:
  ```swift
list[0]   // "Hello"
list[1]   // "World"
list[2]   // crash!
  ```

It crashes on `list[2]` because there is no node at that index.

So far we've written code to add new nodes to the end of the list, but that's slow because you need to find the end of the list first. (It would be fast if we used a tail pointer.) For this reason, if the order of the items in the list doesn't matter, you should insert at the front of the list instead. That's always an **O(1)** operation.

Let's write a method that lets you insert a new node at any index in the list. First, we'll define a helper function:
  ```swift
  private func nodesBeforeAndAfter(index: Int) -> (Node?, Node?) {
    assert(index >= 0)
    
    var i = index
    var next = head
    var prev: Node?

    while next != nil && i > 0 {
      i -= 1
      prev = next
      next = next!.next
    }
    assert(i == 0)

    return (prev, next)
  }
  ```

This returns a tuple containing the node currently at the specified index and the node that immediately precedes it, if any. The loop is very similar to `nodeAtIndex()`, except that here we also keep track of what the previous node is as we iterate through the list. 

Let's look at an example. Suppose we have the following list:

	head --> A --> B --> C --> D --> E --> nil

We want to find the nodes before and after index 3. As we start the loop, `i = 3`, `next` points at `"A"`, and `prev` is nil. 

	head --> A --> B --> C --> D --> E --> nil
	        next

We decrement `i`, make `prev` point to `"A"`, and move `next` to the next node, `"B"`:

	head --> A --> B --> C --> D --> E --> F --> nil
	        prev  next

Again, we decrement `i` and update the pointers. Now `prev` points to `"B"`, and `next` points to `"C"`:

	head --> A --> B --> C --> D --> E --> F --> nil
	              prev  next

As you can see, `prev` always follows one behind `next`. We do this one more time and then `i` equals 0 and we exit the loop:

	head --> A --> B --> C --> D --> E --> F --> nil
	                    prev  next

The `assert()` after the loop checks whether there really were enough nodes in the list. If `i > 0` at this point, then the specified index was too large.

> **Note:** If any of the loops in this article don't make much sense to you, then draw a linked list on a piece of paper and step through the loop by hand, just like what we did here.

For this example, the function returns `("C", "D")` because `"D"` is the node at index 3 and `"C"` is the one right before that.

Now that we have this helper function, we can write the method for inserting nodes:
  ```swift
  public func insert(value: T, atIndex index: Int) {
    let (prev, next) = nodesBeforeAndAfter(index: index)     // 1
    
    let newNode = Node(value: value)    // 2
    newNode.previous = prev
    newNode.next = next
    prev?.next = newNode
    next?.previous = newNode

    if prev == nil {                    // 3
      head = newNode
    }
  }
  ```

Some remarks about this method:

1. First, we need to find where to insert this node. After calling the helper method, `prev` points to the previous node and `next` is the node currently at the given index. We'll insert the new node in between these two. Note that `prev` can be nil (index is 0), `next` can be nil (index equals size of the list), or both can be nil if the list is empty.

2. Create the new node and connect the `previous` and `next` pointers. Because the local `prev` and `next` variables are optionals and may be nil, so we use optional chaining here.

3. If the new node is being inserted at the front of the list, we need to update the `head` pointer. (Note: If the list had a tail pointer, you'd also need to update that pointer here if `next == nil`, because that means the last element has changed.)

Try it out:
  ```swift
list.insert(value:"Swift", atIndex: 1)
list[0]     // "Hello"
list[1]     // "Swift"
list[2]     // "World"
  ```

Also try adding new nodes to the front and back of the list, to verify that this works properly.

> **Note:** The `nodesBeforeAndAfter()` and `insert(atIndex)` functions can also be used with a singly linked list because we don't depend on the node's `previous` pointer to find the previous element.

What else do we need? Removing nodes, of course! First we'll do `removeAll()`, which is really simple:
```swift
  public func removeAll() {
    head = nil
  }
```

If you had a tail pointer, you'd set it to `nil` here too.

Next we'll add some functions that let you remove individual nodes. If you already have a reference to the node, then using `removeNode()` is the most optimal because you don't need to iterate through the list to find the node first. 
```swift
  public func removeNode(node: Node) -> T {
    let prev = node.previous
    let next = node.next
    
    if let prev = prev {
      prev.next = next
    } else {
      head = next
    }
    next?.previous = prev
    
    node.previous = nil
    node.next = nil
    return node.value
  }
```

When we take this node out of the list, we break the links to the previous node and the next node. To make the list whole again we must connect the previous node to the next node.

Don't forget the `head` pointer! If this was the first node in the list then `head` needs to be updated to point to the next node. (Likewise for when you have a tail pointer and this was the last node). Of course, if there are no more nodes left, `head` should become nil.

Try it out:
```swift
list.removeNode(node:list.first!)   // "Hello"
list.count                     // 2
list[0]                        // "Swift"
list[1]                        // "World"
```

If you don't have a reference to the node, you can use `removeLast()` or `removeAtIndex()`:
```swift
  public func removeLast() -> T {
      assert(!isEmpty)
      return removeNode(node:last!)
  }

  public func removeAtIndex(index: Int) -> T {
      let node = nodeAtIndex(index: index)
      assert(node != nil)
      return removeNode(node: node!)
  }
```

All these removal functions also return the value from the removed element. 
```swift
list.removeLast()              // "World"
list.count                     // 1
list[0]                        // "Swift"

list.removeAtIndex(index:0)          // "Swift"
list.count                     // 0
```

> **Note:** For a singly linked list, removing the last node is slightly more complicated. You can't just use `last` to find the end of the list because you also need a reference to the second-to-last node. Instead, use the `nodesBeforeAndAfter()` helper method. If the list has a tail pointer, then `removeLast()` is really quick, but you do need to remember to make `tail` point to the previous node.

There's a few other fun things we can do with our `LinkedList` class. It's handy to have some sort of readable debug output:
```swift
extension LinkedList: CustomStringConvertible {
  public var description: String {
    var s = "["
    var node = head
    while node != nil {
      s += "\(node!.value)"
      node = node!.next
      if node != nil { s += ", " }
    }
    return s + "]"
  }
}
```

This will print the list like so:

	[Hello, Swift, World]

How about reversing a list, so that the head becomes the tail and vice versa? There is a very fast algorithm for that:
```swift
  public func reverse() {
    var node = head
    while let currentNode = node {
      node = currentNode.next
      swap(&currentNode.next, &currentNode.previous)
      head = currentNode
    }
  }
```

This loops through the entire list and simply swaps the `next` and `previous` pointers of each node. It also moves the `head` pointer to the very last element. (If you had a tail pointer you'd also need to update it.) You end up with something like this:

	         +--------+    +--------+    +--------+    +--------+
	tail --->|        |<---|        |<---|        |<---|        |---> nil
	         | node 0 |    | node 1 |    | node 2 |    | node 3 |
	 nil <---|        |--->|        |--->|        |--->|        |<--- head
	         +--------+    +--------+    +--------+    +--------+

Arrays have `map()` and `filter()` functions, and there's no reason why linked lists shouldn't either.
```swift
  public func map<U>(transform: T -> U) -> LinkedList<U> {
    let result = LinkedList<U>()
    var node = head
    while node != nil {
      result.append(value:transform(node!.value))
      node = node!.next
    }
    return result
  }
```

You can use it like this:
```swift
let list = LinkedList<String>()
list.append("Hello")
list.append("Swifty")
list.append("Universe")

let m = list.map { s in s.characters.count }
m  // [5, 6, 8]
```

And here's filter:
```swift
  public func filter(predicate: T -> Bool) -> LinkedList<T> {
    let result = LinkedList<T>()
    var node = head
    while node != nil {
      if predicate(node!.value) {
        result.append(value:node!.value)
      }
      node = node!.next
    }
    return result
  }
```

And a silly example:
```swift
let f = list.filter { s in s.characters.count > 5 }
f    // [Universe, Swifty]
```

#### Formal testing

Now it's time to formally test our linked list data structure.  In the [zipped files for lab3](http://67442.cmuis.net/files/67442/lab3_swift.zip) there is a project that has a `LinkedList.swift` (where your code will go) and a testing file called `LinkedListTests.swift`. The testing file has a basic structure and list of tests, but the actual assertions are left for you to complete. You can look at the tests for the [Deque](https://github.com/profh/67442_Deque) structure we discussed in class or even the tests we wrote for the [slider game](https://github.com/profh/67442_SliderGame) for guidance in writing these assertions. **To get credit for this half of the lab, you must show the TAs your tests passing -- all 16 of them.** Since we've pretty much walked you through the creation of the structure in a playground, it's your testing of it that will convince us you have a good grasp of how linked lists work.

Qapla'


```
  Note: linked list content was adapted from an ASC write-up by Matthijs Hollemans
```
