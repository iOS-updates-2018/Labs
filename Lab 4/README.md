OBJECTIVES
===
- Give students more practice working with models
- Give students more practice working with multiple controllers
- Give students more practice dealing with closures and optionals
- Teach students to incorporate navigation bar to app
- Refresh students' knowledge of data structures
- Improve overall Swift coding ability



CONTENTS
===
There is a flashcard app for Ruby on Rails developers at [https://www.brainscape.com/learn/ruby-on-rails](https://www.brainscape.com/learn/ruby-on-rails) that we will replicate here in a much simpler fashion. 


Flashcards Part 1: Representing, Creating, and Displaying Cards
---
1. Create a new Single View App called "Flashcards".  If you want an AppIcon for this app, you can [get one here](http://67442.cmuis.net/files/67442/lab4/flashcard_images.zip) or [create one here](https://makeappicon.com/). Within the project, create a new, blank Swift file called `Flashcard.swift` and create a simple model named `Flashcard` within this file to represent the essence of a flashcard.  In this case, that means the model has the following:

    - an instance variable called `command` of type String (this is the front of the flashcard with the rails command).
    - an instance variable called `definition` also of type String (this is the back of the flashcard with what the rails command does).
    - a constructor method that takes a command string and a definition string as arguments and sets the appropriate instance variables. 

    In this case use a `struct` not a `class` for this model since this model has only state (properties) and not behavior (methods). (As discussed in class, this is not the primary distinction between structs and classes in Swift, but we will observe this practice here).

2. Create another new file called `Deck.swift` that will help represent a series of flashcards. Within this file, we will define a new class called `Deck`. This will be a class since it will have both state and behavior.  For the state, create an instance variable called `cards` which will be an array of `Flashcard` objects (using the struct we created earlier). In the init method, add the following:
  
    ```swift 
      init() {
      let cardData = [
        "rails generate model ModelName" : "Creates a model with the specified model_name",
        "rails generate migration MigrationName" : "Creates a migration with the specified migration_name",
        "rails generate controller ControllerName" : "Creates a controller with the specified controller_name",
        "rails generate scaffold ModelName" : "Provides shortcut for creating your controller, model and view files in one step",
        "rails destroy scaffold ModelName" : "Destroys the created controller, model and view files that were generated for the given Model",
        "rails server" : "Starts ruby server at http://localhost:3000",
        "rails console" : "Opens the rails console for the current RAILS_ENV",
        "rake test:units" : "Runs all unit tests for the application",
        "rake -T" : "Lists all available rake tasks",
        "rake db:create" : "Creates the database defined in config/database.yml for the current RAILS_ENV",
        "rake db:migrate" : "Migrates teh database through scripts in the db/migrate directory",
        "rake db:drop" : "Drops the database for the current RAILS_ENV",
        "rake db:reset" : "Drops and recreates the database from db/schema.rb for the current environment",
        "rake db:rollback" : "Runs the down method from the latest migration",
        "rake doc:app" : "Builds the RDoc HTML files",
        "gem list" : "lists the gems that this rails application depends on",
        "gem server" : "Presents a web page at http://localhost:8808/ with info about installed gems",
        "bundle install" : "Installs all required gems for this application",
        "rake log:clear" : "Truncates all *.log files in log/ to zero bytes",
        "rake routes" : "Prints out all the defined routes in match order with names",
        "rake tmp:clear" : "Clears session, cache and socket files from tmp/",
        "rake test:benchmark" : "Benchmarks your application"
      ]


      // Now create a simple way to loop through the dictionary and create a Flashcard object 
      // for each card and add that object to the `cards` array we created as an instance variable.
      // This can be done in one line using a closure and I'd encourage you to do so.

      }
      ```

    Replace the comment above with the appropriate closure.  After that add a method that draw a random card (see below):

    ```swift
    func drawRandomCard() -> Flashcard? {
      if cards.isEmpty {  // shouldn't ever really be an issue; just being safe...
        return nil
      } else {
        // return a flashcard object from the deck of cards
        return cards[Int(arc4random_uniform(UInt32(cards.count)))]
      }
    }
    ```

3. Now switch to the View Controller. Here, we are going to create a new deck as well as an optional to hold a flashcard object from that deck:

    ```swift
    let deck = Deck()
    var flashcard: Flashcard? = nil
    ```
 
4. We need some way to display this information. Add some labels to the main storyboard as seen below.  Then turn the second label into an outlet called `commandLabel`.

    ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-2.png)

    Note that you will need to tweak the label in the Identity inspector to allow for multiple lines.

5. Now we need to display the flashcard's `command` property in the in the `commandLabel`. To do that, add to the `viewDidLoad()` method this code that will draw and display a random flashcard.  Remember that flashcard is technically an optional, so we will safely unpack it with `if let ...`  

    ```swift
      if let flashcard = deck.drawRandomCard() {
        self.flashcard = flashcard
        commandLabel?.text = flashcard.command
      }
    ```

    Build and run the app to see that it is randomly drawing and displaying the contents of a card. For now you should see the bottom portion of the flashcard upadting with a new rails command, with the top unchanged.

    We will now work to make our flashcards flippable and add the definition to the cards as well.

Flashcards Part 2: Adding Navigation
---
1. Add a second view controller similar to what we did last week that we will use to display the definition part of the card.  First is to add a new file to the project called `DefinitionViewController.swift` and then add a new view controller to the storyboard to the right of the current one.  Make sure that in the Identity inspector you set the class on the new view controller to `DefinitionViewController`. (In some cases you might have Xcode issue a warning after selecting the custom class; if so click into the module text box just below and just hit enter.)

1. To add the navigation bar to the app, select the first view controller and then go to the menu `Editor` option and select `Embed in...` > `Navigation Controller`.  This will add the navigation controller and a navbar to the view controller.  In the Object Library select the `Bar Button Item` and drag it to the right side of the navbar.  Double-click on navbar and add in 'Command' in the text box that appears.

1. In the Attribute Inspector look at the options under `Identifier` to see how many built-in options are available, but in our case choose 'custom' and set the title to 'Definition'. Now `control click` on the button and drag it to the definition view controller.  Choose the `show` option when creating the seque. Click on the seque in the storyboard and look at Attribute Inspector; change the identifier to `showDefinition`.  Build and run the app and see how the two pages are connected via the navbar.

1. Now we need to add some labels to the definition view controller as seen below.  Make outlets for these labels; the top one in Courier New font is `commandLabel` and the bottom one is `definitionLabel` and you should adjust both to allow for multiple lines. 

  ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-3.png)

  In the code for `DefinitionViewController` add in an instance variable for the flashcard:

  ```swift
  var flashcard: Flashcard?
  ```

  And then in the `viewDidLoad()` method add in:

  ```swift
    // we need to safely unpack the flashcard and display the data, if present
    if let card = flashcard {
      commandLabel.text = card.command
      definitionLabel.text = card.definition
    }
  ```

  We can run it now, but it won't do anything because `flashcard` is an optional (rightly so) and in this case, it is `nil` -- we haven't transferred the flashcard object from the main view controller to this one.

1. To do this, go back to the main view controller and add in the following code:

  ```swift
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showDefinition" {
      let showDefinition:DefinitionViewController = segue.destinationViewController as! DefinitionViewController
      showDefinition.flashcard = self.flashcard
    }
  }
  ```

  This is what we saw in the class demo this past week. This function is run just before we seque to the definition view controller and basically sets the instance variable in the definition view controller to our flashcard object that was randomly drawn.  Build and run this project now and you should see the data connected.

1. One problem is that when you go back, you still see the same rails command; do you have to keep quitting and reloading the app to get new questions? No, but first we need to recognize that iOS gives us a lot of [valid state transitions](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instm/UIViewController/viewWillAppear:) to work with as seen at link and in the image below:

  ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-4.png)

  If we override the built-in iOS function `viewWillAppear()` then we can make sure a new card is drawn each time we return to this view.  In the code for the main view controller, comment out the lines in `viewDidLoad()` that generated the card and instead add the following:

  ```swift
  // because we really want a new card every time this view appears
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    if let flashcard = deck.drawRandomCard() {
      self.flashcard = flashcard
      commandLabel.text = flashcard.command
    }
  }
  ```

  Now build and run and we should be getting the behavior we anticipated.

1. Bonus time: use AutoLayout to set up constraints so that all the elements on your storyboards are displayed accurately on multiple devices. You can look at the slider game project for examples (use the size inspector to see the constraints more precisely).


---
Part B: Binary Trees and Heaps (Swift)
---

> **Note**: if you feel strong about your knowledge of data structures in general and binary trees and heaps in particular, you can skip ahead to the final part of the lab on testing; that is the only deliverable you are required to show TAs this week.

On to data structures...

A tree is a foundational data structure that represents hierarchical relationships between objects. A tree consists of nodes, and these nodes are linked to one another. Nodes have links to their children and usually to their parent as well. The children are the nodes below a given node; the parent is the node above. A node always has just one parent but can have multiple children.

A binary tree is a specific type of tree where each node has either 0, 1, or 2 children. The image below is an example of a binary tree:

![](http://67442.cmuis.net/screenshots/67442/lab4/BinaryTree.png)

The child nodes are usually called the *left* child and the *right* child. If a node doesn't have any children, it's called a *leaf* node. The *root* is the node at the very top of the tree (programmers like their trees upside down). Often nodes will have a link back to their parent but this is not strictly necessary.

#### Building a binary tree in a playground

Here's how you could implement a general-purpose binary tree in Swift:

```swift
public indirect enum BinaryTree<T> {
  case Node(BinaryTree<T>, T, BinaryTree<T>)
  case Empty
}
```

As an example of how to use this, let's build that tree of arithmetic operations:

```swift
// leaf nodes
let node5 = BinaryTree.Node(.Empty, "5", .Empty)
let nodeA = BinaryTree.Node(.Empty, "a", .Empty)
let node10 = BinaryTree.Node(.Empty, "10", .Empty)
let node4 = BinaryTree.Node(.Empty, "4", .Empty)
let node3 = BinaryTree.Node(.Empty, "3", .Empty)
let nodeB = BinaryTree.Node(.Empty, "b", .Empty)

// intermediate nodes on the left
let Aminus10 = BinaryTree.Node(nodeA, "-", node10)
let timesLeft = BinaryTree.Node(node5, "*", Aminus10)

// intermediate nodes on the right
let minus4 = BinaryTree.Node(.Empty, "-", node4)
let divide3andB = BinaryTree.Node(node3, "/", nodeB)
let timesRight = BinaryTree.Node(minus4, "*", divide3andB)

// root node
let tree = BinaryTree.Node(timesLeft, "+", timesRight)
```

You need to build up the tree in reverse, starting with the leaf nodes and working your way up to the top.

It will be useful to add a `description` method so you can print the tree:

```swift
extension BinaryTree: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .Node(left, value, right):
      return "value: \(value), left = [" + left.description + "], right = [" 
                                         + right.description + "]"
    case .Empty:
      return ""
    }
  }
}
```

If you `print(tree)` you should see something like this:

	value: +, left = [value: *, left = [value: 5, left = [], right = []], right = [value: -, left = [value: a, left = [], right = []], right = [value: 10, left = [], right = []]]], right = [value: *, left = [value: -, left = [], right = [value: 4, left = [], right = []]], right = [value: /, left = [value: 3, left = [], right = []], right = [value: b, left = [], right = []]]]

With a bit of imagination, you can see the tree structure. ;-) It helps if you indent it:

	value: +, 
		left = [value: *, 
			left = [value: 5, left = [], right = []], 
			right = [value: -, 
				left = [value: a, left = [], right = []], 
				right = [value: 10, left = [], right = []]]], 
		right = [value: *, 
			left = [value: -, 
				left = [], 
				right = [value: 4, left = [], right = []]], 
			right = [value: /, 
				left = [value: 3, left = [], right = []], 
				right = [value: b, left = [], right = []]]]

Another useful method is counting the number of nodes in the tree:

```swift
  public var count: Int {
    switch self {
    case let .Node(left, _, right):
      return left.count + 1 + right.count
    case .Empty:
      return 0
    }
  }
```

On the tree from the example, `tree.count` should be 12.

Something you often need to do with trees is traverse them, i.e. look at all the nodes in some order. There are three ways to traverse a binary tree:

1. *In-order* (or *depth-first*): first look at the left child of a node, then at the node itself, and finally at its right child.
2. *Pre-order*: first look at a node, then at its left and right children. 
3. *Post-order*: first look at the left and right children and process the node itself last.

Here is how you'd implement that:

```swift
  public func traverseInOrder(@noescape process: T -> Void) {
    if case let .Node(left, value, right) = self {
      left.traverseInOrder(process)
      process(value)
      right.traverseInOrder(process)
    }
  }
  
  public func traversePreOrder(@noescape process: T -> Void) {
    if case let .Node(left, value, right) = self {
      process(value)
      left.traversePreOrder(process)
      right.traversePreOrder(process)
    }
  }
  
  public func traversePostOrder(@noescape process: T -> Void) {
    if case let .Node(left, value, right) = self {
      left.traversePostOrder(process)
      right.traversePostOrder(process)
      process(value)
    }
  }
```

As is common when working with tree structures, these functions call themselves recursively.

For example, if you traverse the tree of arithmetic operations in post-order, you'll see the values in this order:

	5
	a
	10
	-
	*
	4
	-
	3
	b
	/
	*
	+

The leaves appear first. The root node appears last.

You can use a stack machine to evaluate these expressions, something like the following pseudocode:

```swift
tree.traversePostOrder { s in 
  switch s {
  case this is a numeric literal, such as 5:
    push it onto the stack
  case this is a variable name, such as a:
    look up the value of a and push it onto the stack
  case this is an operator, such as *:
    pop the two top-most items off the stack, multiply them,
    and push the result back onto the stack
  }
  the result is in the top-most item on the stack
}
```

#### Moving on to heaps

A heap is a type of binary tree that lives inside an array, so it doesn't use parent/child pointers. The tree is partially sorted according to something called the "heap property" that determines the order of the nodes in the tree.

Common uses for heap:

- For building priority queues.
- The heap is the data structure supporting heap sort.
- Heaps are fast for when you often need to compute the minimum (or maximum) element of a collection.

There are two kinds of heaps: a *max-heap* and a *min-heap*. They are identical, except that the order in which they store the tree nodes is opposite.

In a max-heap, parent nodes must always have a greater value than each of their children. For a min-heap it's the other way around: every parent node has a smaller value than its child nodes. This is called the "heap property" and it is true for every single node in the tree.

An example:

![](http://67442.cmuis.net/screenshots/67442/lab4/Heap1.png)

This is a max-heap because every parent node is greater than its children. `(10)` is greater than `(7)` and `(2)`. `(7)` is greater than `(5)` and `(1)`.

As a result of this heap property, a max-heap always stores its largest item at the root of the tree. For a min-heap, the root is always the smallest item in the tree. That is very useful because heaps are often used as a priority queue where you want to quickly access the "most important" element.

> **Note:** You can't really say anything else about the sort order of the heap. For example, in a max-heap the maximum element is always at index 0 but the minimum element isn’t necessarily the last one -- the only guarantee you have is that it is one of the leaf nodes, but not which one.

#### The tree that lived in an array

An array may seem like an odd way to implement a tree-like structure but it is very efficient in both time and space.

This is how we're going to store the tree from the above example:

	[ 10, 7, 2, 5, 1 ]

That's all there is to it! We don't need any more storage than just this simple array.

So how do we know which nodes are the parents and which are the children if we're not allowed to use any pointers? Good question! There is a well-defined relationship between the array index of a tree node and the array indices of its parent and children.

If `i` is the index of a node, then the following formulas give the array indices of its parent and child nodes:

    parent(i) = floor((i - 1)/2)
    left(i)   = 2i + 1
    right(i)  = 2i + 2
    
Note that `right(i)` is simply `left(i) + 1`. The left and right nodes are always stored right next to each other.

Let's use these formulas on the example. Fill in the array index and we should get the positions of the parent and child nodes in the array:

| Node | Array index (`i`) | Parent index | Left child | Right child |
|------|-------------|--------------|------------|-------------|
| 10 | 0 | -1 | 1 | 2 |
| 7 | 1 | 0 | 3 | 4 |
| 2 | 2 | 0 | 5 | 6 | 
| 5 | 3 | 1 | 7 | 8 |
| 1 | 4 | 1 | 9 | 10 |

Verify for yourself that these array indices indeed correspond to the picture of the tree.

> **Note:** The root node `(10)` doesn't have a parent because `-1` is not a valid array index. Likewise, nodes `(2)`, `(5)`, and `(1)` don't have children because those indices are greater than the array size. So we always have to make sure the indices we calculate are actually valid before we use them.

Recall that in a max-heap, the parent's value is always greater than (or equal to) the values of its children. This means the following must be true for all array indices `i`:

```swift
array[parent(i)] >= array[i]
```
	
Verify that this heap property holds for the array from the example heap.

As you can see, these equations let us find the parent or child index for any node without the need for pointers. True, it's slightly more complicated than just dereferencing a pointer but that's the tradeoff: we save memory space but pay with extra computations. Fortunately, the computations are fast and only take **O(1)** time.

It's important to understand this relationship between array index and position in the tree. Here's a slightly larger heap, this tree has 15 nodes divided over four levels:

![](http://67442.cmuis.net/screenshots/67442/lab4/LargeHeap.png)

The numbers in this picture aren't the values of the nodes but the array indices that store the nodes! Those array indices correspond to the different levels of the tree like this:

![](http://67442.cmuis.net/screenshots/67442/lab4/Array.png)

For the formulas to work, parent nodes must always appear before child nodes in the array. You can see that in the above picture.

Note that this scheme has limitations. You can do the following with a regular binary tree but not with a heap:

![](http://67442.cmuis.net/screenshots/67442/lab4/RegularTree.png)

With a heap you can’t start a new level unless the current lowest level is completely full. 

#### What can you do with a heap?

There are two primitive operations necessary to make sure the heap is a valid max-heap or min-heap after you insert or remove an element:

- `shiftUp()`: If the element is greater (max-heap) or smaller (min-heap) than its parent, it needs to be swapped with the parent. This makes it move up the tree.

- `shiftDown()`. If the element is smaller (max-heap) or greater (min-heap) than its children, it needs to move down the tree. This operation is also called "heapify". 

Shifting up or down is a recursive procedure that takes **O(log n)** time.

The other operations are built on these primitives. They are:

- `insert(value)`: Adds the new element to the end of the heap and then uses `shiftUp()` to fix the heap.

- `remove()`: Removes and returns the maximum value (max-heap) or the minimum value (min-heap). To fill up the hole that's left by removing the element, the very last element is moved to the root position and then `shiftDown()` fixes up the heap. (This is sometimes called "extract min" or "extract max".)

- `removeAtIndex(index)`: Just like `remove()` except it lets you remove any item from the heap, not just the root. This calls both `shiftDown()`, in case the new element is out-of-order with its children, and `shiftUp()`, in case the element is out-of-order with its parents.

- `replace(index, value)`: Assigns a smaller (min-heap) or larger (max-heap)  value to a node. Because this invalidates the heap property, it uses `shiftUp()` to patch things up. (Also called "decrease key" and "increase key".)

All of the above take time **O(log n)** because shifting up or down is the most expensive thing they do. There are also a few operations that take more time:

- `search(value)`. Heaps aren't built for efficient searches but the `replace()` and `removeAtIndex()` operations require the array index of the node, so you need to find that index somehow. Time: **O(n)**.

- `buildHeap(array)`: Converts an (unsorted) array into a heap by repeatedly calling `shiftDown()`. If you’re smart about this, it can be done in **O(n)** time.

- Heap sort. Since the heap is really an array, we can use its unique properties to sort the array from low to high. Time: **O(n lg n).**

The heap also has a `peek()` function that returns the maximum (max-heap) or minimum (min-heap) element, without removing it from the heap. Time: **O(1)**.

**Note:** By far the most common things you'll do with a heap are inserting new values with `insert()` and removing the maximum or minimum value with `remove()`. Both take **O(log n)** time. The other operations exist to support more advanced usage, such as building a priority queue where the "importance" of items can change after they've been added to the queue.

#### Creating a heap from an array

It can be convenient to convert an array into a heap. This just shuffles the array elements around until the heap property is satisfied.

In code it would look like this:

```swift
  private mutating func buildHeap(array: [T]) {
    for value in array {
      insert(value)
    }
  }
```

We simply call `insert()` for each of the values in the array. Simple enough, but not very efficient. This takes **O(n log n)** time in total because there are **n** elements and each insertion takes **log n** time.

If you didn't gloss over the math section, you'd have seen that for any heap the elements at array indices *n/2* to *n-1* are the leaves of the tree. We can simply skip those leaves. We only have to process the other nodes, since they are parents with one or more children and therefore may be in the wrong order. 

In code:

```swift
  private mutating func buildHeap(array: [T]) {
    elements = array
    for i in (elements.count/2 - 1).stride(through: 0, by: -1) {
      shiftDown(index: i, heapSize: elements.count)
    }
  }
```

Here, `elements` is the heap's own array. We walk backwards through this array, starting at the first non-leaf node, and call `shiftDown()`. This simple loop puts these nodes, as well as the leaves that we skipped, in the correct order. This is known as Floyd's algorithm and only takes **O(n)** time. Win!

#### Searching the heap

Heaps aren't made for fast searches, but if you want to remove an arbitrary element using `removeAtIndex()` or change the value of an element with `replace()`, then you need to obtain the index of that element somehow. Searching is one way to do this but it's kind of slow.

In a binary search tree you can depend on the order of the nodes to guarantee a fast search. A heap orders its nodes differently and so a binary search won't work. You'll potentially have to look at every node in the tree.

Let's take our example heap again:

![](http://67442.cmuis.net/screenshots/67442/lab4/Heap1.png)

If we want to search for the index of node `(1)`, we could just step through the array `[ 10, 7, 2, 5, 1 ]` with a linear search.

But even though the heap property wasn't conceived with searching in mind, we can still take advantage of it. We know that in a max-heap a parent node is always larger than its children, so we can ignore those children (and their children, and so on...) if the parent is already smaller than the value we're looking for.

Let's say we want to see if the heap contains the value `8` (it doesn't). We start at the root `(10)`. This is obviously not what we're looking for, so we recursively look at its left and right child. The left child is `(7)`. That is also not what we want, but since this is a max-heap, we know there's no point in looking at the children of `(7)`. They will always be smaller than `7` and are therefore never equal to `8`. Likewise for the right child, `(2)`.

Despite this small optimization, searching is still an **O(n)** operation.

**Note:** There is away to turn lookups into a **O(1)** operation by keeping an additional dictionary that maps node values to indices. This may be worth doing if you often need to call `replace()` to change the "priority" of objects in a priority queue that's built on a heap.

#### Putting heaps to the test

At this point, we want to put our knowledge of heaps to the test - literally. Download the [starter code for heaps](http://67442.cmuis.net/files/67442/lab4/Heap_starter.zip) and open the project.  In it, you have a complete set of tests that your heap data structure has to pass.  You also have the framework for the heap data structure and some key methods given to you, along with plenty of comments on each method.  These comments, along with the tests -- which we've said in 67-272 serve as another (in many cases, better) form of documentation -- should help you complete the data structure and pass all the tests.  Show these tests passing to the TAs this week and you will get full credit for the Swift portion of the lab.

Qapla'


```
  Note: data structures content was adapted from an ASC write-up by Matthijs Hollemans
```
