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
    self.elements = array
    if self.count < 2 {
      return
    }
    let start = (self.count - 2) / 2
    for i in 0...start {
      self.shiftDown(index: start - i, heapSize: self.elements.count)
    }
  }
  
  public var isEmpty: Bool {
    return self.elements.isEmpty
  }
  
  public var count: Int {
    return self.elements.count
  }
  
  // Returns the index of the parent of the element at index i.
  // The element at index 0 is the root of the tree and has no parent.
  @inline(__always) func indexOfParent(i: Int) -> Int {
    return (i - 1) / 2
  }
  
  // Returns the index of the left child of the element at index i.
  // Note that this index can be greater than the heap size, in which
  // case there is no left child.
  @inline(__always) func indexOfLeftChild(i: Int) -> Int {
    return 2 * i + 1
  }
  
  // Returns the index of the right child of the element at index i.
  // Note that this index can be greater than the heap size, in which
  // case there is no right child.
  @inline(__always) func indexOfRightChild(i: Int) -> Int {
    return self.indexOfLeftChild(i: i) + 1
  }
  
  // Returns the maximum value in the heap (for a max-heap) or the minimum
  
  public func peek() -> T? {
    if elements.count > 0 { return elements[0] }
    else {return nil}
  }
  
  // Adds a new value to the heap. This reorders the heap
  // so that the max-heap or min-heap property still holds.
  public mutating func insert(value: T) {
    self.elements.append(value)
    shiftUp(index: elements.count - 1)
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
    if self.isOrderedBefore(value, self.elements[i]){
      self.elements[i] = value
      self.shiftUp(index: i)
    }
  }
  
  // Removes the root node from the heap. For a max-heap, this
  // is the maximum value; for a min-heap it is the minimum value.
  
  public mutating func remove() -> T? {
    if self.elements.count > 0 {
      return removeAtIndex(i: 0)
    }
    return nil
  }
  
  // Removes an arbitrary node from the heap.
  
  public mutating func removeAtIndex(i: Int) -> T? {
    let valueRemoved = self.elements[i]
    if self.elements.count == 1 {
      self.elements = []
      return valueRemoved}
    if i != self.elements.count - 1 {
      self.elements.swapAt(i, self.elements.count - 1)}
    self.elements.removeLast()
    for index in 0..<self.elements.count {
      self.shiftDown(index: index, heapSize: self.elements.count)
      self.shiftUp(index: index)
    }
    return valueRemoved
  }
  
  // Takes a child node and looks at its parents; if a parent is
  // not larger (max-heap) or not smaller (min-heap) than the
  // child, we exchange them.
  
  mutating func shiftUp(index: Int) {
    if index <= 0 {return} else {
      if self.isOrderedBefore(self.elements[index], self.elements[self.indexOfParent(i: index)]) {
        self.elements.swapAt(index, self.indexOfParent(i: index))
        return shiftUp(index: self.indexOfParent(i: index))
      }
    }
  }
  
  mutating func shiftDown() {
    return shiftDown(index: 0, heapSize: self.elements.count)
  }
  
  // Looks at a parent node and makes sure it is still larger
  // (max-heap) or smaller (min-heap) than its children.
  
  mutating func shiftDown(index: Int, heapSize: Int) {
    if self.indexOfLeftChild(i: index) >= heapSize && self.indexOfRightChild(i: index) >= heapSize {return}
    if self.indexOfLeftChild(i: index) < heapSize && self.indexOfRightChild(i: index) >= heapSize {
      if self.isOrderedBefore(self.elements[self.indexOfLeftChild(i: index)], self.elements[index]){
        self.elements.swapAt(self.indexOfLeftChild(i: index), index)
        return
      }
    }
    else {
      let minElem = self.isOrderedBefore(self.elements[self.indexOfLeftChild(i: index)], self.elements[self.indexOfRightChild(i: index)])
      var minIndex = self.indexOfRightChild(i: index)
      if minElem {minIndex = self.indexOfLeftChild(i: index)}
      if self.isOrderedBefore(self.elements[minIndex], self.elements[index]){
        self.elements.swapAt(minIndex, index)
        return shiftDown(index: minIndex, heapSize: heapSize)
      }
      
    }
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

