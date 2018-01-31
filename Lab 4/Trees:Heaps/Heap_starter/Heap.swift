//
//  Heap.swift


public struct Heap<T> {
  // The array that stores the heap's nodes.
  var elements = [T]()
  
  // Determines whether this is a max-heap (>) or min-heap (<).
  private var isOrderedBefore: (T, T) -> Bool
  
  // Init for creating an empty heap.
  // The sort function determines whether this is a min-heap or max-heap.
  // For integers, > makes a max-heap, < makes a min-heap.
  public init(sort: @escaping (T, T) -> Bool) {
    self.isOrderedBefore = sort
  }
  
  // Init for creating a heap from an array.
  public init(array: [T], sort: @escaping (T, T) -> Bool) {
    self.isOrderedBefore = sort
    buildHeap(array: array)
  }
  
  
  // Converts an array to a max-heap or min-heap in a bottom-up manner.
  private mutating func buildHeap(array: [T]) {

  }
  
  public var isEmpty: Bool {

  }
  
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
  
  public mutating func insert<S: Sequence>(sequence: S) where S.Iterator.Element == T {
    for value in sequence {
      insert(value: value)
    }
  }
  
  
  // Allows you to change an element. In a max-heap, the new
  // element should be larger than the old one; in a min-heap
  // it should be smaller.
  public mutating func replace(index i: Int, value: T) {

  }
  
  // Removes the root node from the heap. For a max-heap, this
  // is the maximum value; for a min-heap it is the minimum value.
  
  public mutating func remove() -> T? {

  }
  
  // Removes an arbitrary node from the heap.
  
  public mutating func removeAtIndex(i: Int) -> T? {

  }
  
  // Takes a child node and looks at its parents; if a parent is
  // not larger (max-heap) or not smaller (min-heap) than the
  // child, we exchange them.
  
  mutating func shiftUp(index: Int) {

  }
  
  mutating func shiftDown() {

  }
  
  // Looks at a parent node and makes sure it is still larger
  // (max-heap) or smaller (min-heap) than its children.
  
  mutating func shiftDown(index: Int, heapSize: Int) {
    
  }
}

// MARK: - Searching

extension Heap where T: Equatable {
  // Searches the heap for the given element.
  
  public func indexOf(element: T) -> Int? {
    return indexOf(element: element, 0)
  }
  
  private func indexOf(element: T, _ i: Int) -> Int? {
    if i >= count { return nil }
    if isOrderedBefore(element, elements[i]) { return nil }
    if element == elements[i] { return i }
    if let j = indexOf(element: element, indexOfLeftChild(i: i)) { return j }
    if let j = indexOf(element: element, indexOfRightChild(i: i)) { return j }
    return nil
  }
}

