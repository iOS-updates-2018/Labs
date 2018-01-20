/*
  Last-in first-out stack (LIFO)

  Push and pop are O(1) operations.
*/
public struct Stack<T> {
  public var array = [T]()
  
  public var count: Int{
    return array.count
  }
  public var isEmpty: Bool{
    return array.count == 0
  }
  
  public mutating func push(element: T) {
    array.append(element)
  }
  
  public mutating func pop() -> T? {
    if (count == 0){
      return nil
    }
    let lastElement = array[count - 1]
    self.array.removeLast()
    return lastElement
  }
  
  public func peek() -> T? {
    if (count == 0){
      return nil
    }
    return array[count - 1]
  }
}
