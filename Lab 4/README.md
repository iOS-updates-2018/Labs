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

Ours is much similar, with plenty of room for creative freedom. Here is a look at the project (two screens, one to show the command and the flipside to show the definition):

<p float="left">
  <img src="https://i.imgur.com/eXT8Gx8.png" width="48%" />
  <img src="https://i.imgur.com/QgOM3aG.png" width="48%" /> 
</p>


Flashcards Part 1: Representing, Creating, and Displaying Cards
---
1. Create a new Single View App called "Flashcards".  If you want an AppIcon for this app, you can [get one here](http://67442.cmuis.net/files/67442/lab4/flashcard_images.zip) or [create one here](https://makeappicon.com/). Within the project, create a new, blank Swift file called `Flashcard.swift` and create a simple model named `Flashcard` within this file to represent the essence of a flashcard.  In this case, that means the model has the following:
    - an instance variable called `command` of type String (this is the front of the flashcard with the rails command).
    - an instance variable called `definition` also of type String (this is the back of the flashcard with what the rails command does).
    - a constructor method that takes a command string and a definition string as arguments and sets the appropriate instance variables. 

    In this case use a `struct` not a `class` for this model since this model has only state (properties) and not behavior (methods). (As discussed in class, this is not the primary distinction between structs and classes in Swift, but we will observe this practice here).

2. Create another new file called `Deck.swift` that will help represent a series of flashcards. Within this file, we will define a new class called `Deck`. This will be a class since it will have both state and behavior.  For the state, create an instance variable called `cards` which will be an array of `Flashcard` objects (using the struct we created earlier). Afterwards, in the `init` method, set the body of the method to the following code:
  
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

3. Now switch to the `View Controller` code. Here, we are going to create a new deck as well as an optional to hold a flashcard object from that deck:

    ```swift
    let deck = Deck()
    var flashcard: Flashcard?
    ```
 
4. We need some way to display this information. Add some labels to the main storyboard as seen below.  Then turn the lower label into an outlet called `commandLabel`.

    ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-2.png)

    Note that you will need to tweak the label in the Identity inspector to allow for multiple lines. To allow this, set the number of lines to 0 and then expand the size of the label box to allow for more content to be seen. Be sure to then center the text as well if you do so!

5. Now we need to display the flashcard's `command` property in the in the `commandLabel`. To do that, add to the `viewDidLoad()` method this code that will draw and display a random flashcard.  Remember that flashcard is technically an optional, so we will safely unpack it with `if let ...`  

    ```swift
      if let flashcard = deck.drawRandomCard() {
        self.flashcard = flashcard
        commandLabel?.text = flashcard.command
      }
    ```

    Build and run the app to see that it is randomly drawing and displaying the contents of a card. For now you should see the bottom portion of the flashcard upadting with a new rails command, with the top unchanged. It should look something like this (with a new command generated each time):

      <img src="https://i.imgur.com/B4phCIl.png" width="50%"/>

    We will now work to make our flashcards flippable and add the definition to the cards as well.

Flashcards Part 2: Adding Navigation
---
1. Now we will go through creating a second view controller which we will use to display the definition part of the card.  First is to add a new Cocoa Touch Class file to the project called `DefinitionViewController.swift`, with the class of `DefinitionViewController` and is a subclass of `UIViewController`. 

    Then in the storyboard add a new view controller to the storyboard to the right of the current one.  Make sure that in the Identity inspector you set the class on the new view controller to `DefinitionViewController`. (In some cases you might have Xcode issue a warning after selecting the custom class; if so click into the module text box just below and just hit enter.)

2. To add the navigation bar to the app, select the first view controller and then, on the top XCode menu, select the `Editor` option and select `Embed in...` > `Navigation Controller`.  This will add the navigation controller and a navbar to the View Controller.  In the Object Library select the `Bar Button Item` and drag it to the right side of the top navbar on the original View Controller.  Replace the button text of this new button with 'Definition' and set the navbar title to 'Command'. The navigation in the storyboard should now look like the following (minus the `DefinitionViewController`, which we will wire in shortly! It should be empty now):

    <img src="https://i.imgur.com/RrZuf4c.png" width="75%">

3. Now `control click` on the button and drag it to the definition view controller.  Choose the `show` option when creating the seque. Click on the seque in the storyboard and look at Attribute Inspector; change the identifier to `showDefinition`.  Build and run the app and see how the two pages are connected via the navbar. Also note how the title of the navbar in the first View Controller automatically set the back button in the second View Controller.

4. Now we need to add some labels to the Definition View Controller as seen below.  Make outlets for these labels; the top one is `commandLabel`, the bottom one is `definitionLabel` and you should adjust both to allow for multiple lines. 

    ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-3.png)

    In the code for `DefinitionViewController` add in an instance variable for the flashcard:

    ```swift
    var flashcard: Flashcard?
    ```

    And then in the `viewDidLoad()` method add in:

    ```swift
      // we need to safely unpack the flashcard and display the data, if present
      if let card = flashcard {
        commandLabel?.text = card.command
        definitionLabel?.text = card.definition
      }
    ```

    We can run it now, but it won't do anything because `flashcard` is an optional (rightly so) and in this case, it is `nil` -- we haven't transferred the flashcard object from the main view controller to this one.

5. To do this, go back to the main view controller and add in the following code:

    ```swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "showDefinition" {
        let showDefinition:DefinitionViewController = segue.destination as! DefinitionViewController
        showDefinition.flashcard = self.flashcard
      }
    }
    ```

    This is what we saw in the class demo this past week. This function is run just before we seque to the definition view controller and basically sets the instance variable in the definition view controller to our flashcard object that was randomly drawn.  Build and run this project now and you should see the data connected.

6. One problem is that when you go back, you still see the same rails command; do you have to keep quitting and reloading the app to get new questions? No, but first we need to recognize that iOS gives us a lot of [valid state transitions](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIViewController_Class/#//apple_ref/occ/instm/UIViewController/viewWillAppear:) to work with as seen at link and in the image below:

    ![](http://67442.cmuis.net/screenshots/67442/lab5/lab5-4.png)

    If we override the built-in iOS function `viewWillAppear()` then we can make sure a new card is drawn each time we return to this view.  In the code for the main view controller, comment out the lines in `viewDidLoad()` that generated the card and instead add the following:

    ```swift
    // because we really want a new card every time this view appears
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let flashcard = deck.drawRandomCard() {
        self.flashcard = flashcard
        commandLabel?.text = flashcard.command
      }
    }
    ```

    Now build and run and we should be getting the behavior we anticipated.

7. **Bonus time**: use AutoLayout to set up constraints so that all the elements on your storyboards are displayed accurately on multiple devices. You can look at the slider game project for examples (use the size inspector to see the constraints more precisely).


---
Part B: Binary Trees and Heaps (Swift)
---

> **Note**: if you feel strong about your knowledge of data structures in general and binary trees and heaps in particular, you can skip ahead to the final part of the lab on testing; that is the only deliverable you are required to show TAs this week.

On to data structures...

This week, we will be revisiting the Binary Tree and Heap data structures. Below, we will lay out the general interface for trees and heaps you are expected to implement, with testing. For Binary Trees, you are to write tests to cover the functions defined in the enum, and then implement the Binary Tree. For Heaps, you are to implement the interface to have the given tests pass! Download the starter code here and fill in the interfaces for Heaps, and test!

For more information on trees, [review the README here](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%204/Trees:Heaps/Tree_starter) if need be and [work off of this starter code](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%204/Trees:Heaps/Tree_starter).

For more information on heaps, [review the README here](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%204/Trees:Heaps/Heap_starter) if need be and [work off of this starter code](https://github.com/iOS-updates-2018/Labs/tree/master/Lab%204/Trees:Heaps/Heap_starter).

### Binary Trees Interface (Using Enums)

```swift
public indirect enum BinaryTree<T> {
  case Node(BinaryTree<T>, T, BinaryTree<T>)
  case Empty
  
  public func count() -> Int {
    // Dynamically updated property: the number of non-empty nodes in the binary tree
  }
  
  public func traverseInOrder() -> [T] {
    // Returns a list of the objects in the tree in left subtree, current node, right subtree order
  }
  
  public func isEmpty() -> Bool {
    // Returns true if this tree is Empty and false otherwise
    // Note that this is a more convenient way than switching on .Empty
  }
  
  public func containsValue(t: T) -> T? {
    // Returns an optional with some(t) if t is present in the Binary Tree, and
    // nil otherwise
  }
  
}
```


### Heaps Interface (Using Array-List Representation)

```swift
public struct Heap<T> {
  // The array that stores the heap's nodes.
  var elements = [T]()

  // Determines whether this is a max-heap (>) or min-heap (<).
  private var isOrderedBefore: (T, T) -> Bool

  // Init for creating an empty heap.
  // The sort function determines whether this is a min-heap or max-heap.
  // For integers, > makes a max-heap, < makes a min-heap.
  public init(sort: (T, T) -> Bool) {
    self.isOrderedBefore = sort
  }

  // Init for creating a heap from an array. 
  public init(array: [T], sort: (T, T) -> Bool) {
    self.isOrderedBefore = sort
    buildHeap(array)
  }


  // Converts an array to a max-heap or min-heap in a bottom-up manner.
  private mutating func buildHeap(array: [T]) {
 
  }

  // Returns true if the tree is empty and false otherwise
  public var isEmpty: Bool {

  }

  // Returns the number of non-empty nodes in the tree
  public var count: Int {

  }

  // Returns the index of the parent of the element at index i.
  // The element at index 0 is the root of the tree and has no parent.
  @inline(__always) func indexOfParent(i: Int) -> Int {

  }

  // Returns the index of the left child of the element at index i.
  // Note that this index can be greater than the heap size, in which
  // case there is no left child.
  @inline(__always) func indexOfLeftChild(i: Int) -> Int {

  }

  // Returns the index of the right child of the element at index i.
  // Note that this index can be greater than the heap size, in which 
  // case there is no right child.
  @inline(__always) func indexOfRightChild(i: Int) -> Int {

  }

  // Returns the maximum value in the heap (for a max-heap) or the minimum
  public func peek() -> T? {

  }

  // Adds a new value to the heap. This reorders the heap 
  // so that the max-heap or min-heap property still holds.
  public mutating func insert(value: T) {

  }
  
  public mutating func insert<S: SequenceType>(sequence: S) where S.Generator.Element == T {
    for value in sequence {
      insert(value)
    }
  }

  // Removes the root node from the heap. For a max-heap, this 
  // is the maximum value; for a min-heap it is the minimum value.
  public mutating func remove() -> T? {

  }

  // Takes a child node and looks at its parents; if a parent is 
  // not larger (max-heap) or not smaller (min-heap) than the 
  // child, we exchange them.
  mutating func shiftUp(index: Int) {

  }

  // Looks at a parent node and makes sure it is still larger 
  // (max-heap) or smaller (min-heap) than its children.
  mutating func shiftDown(index: Int, heapSize: Int) {
  }
}
```

```
  Note: data structures content was adapted from an ASC write-up by Matthijs Hollemans
```
