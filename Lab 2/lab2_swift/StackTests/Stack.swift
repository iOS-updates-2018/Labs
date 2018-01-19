/*
  Last-in first-out stack (LIFO)

  Push and pop are O(1) operations.
*/
public struct Stack<T> {
  private var array = [T]()

  public var isEmpty: Bool {

  }

  public var count: Int {

  }

  public mutating func push(element: T) {

  }

  public mutating func pop() -> T? {

  }

  public func peek() -> T? {

  }
}

extension Stack: SequenceType {
    public func generate() -> AnyGenerator<T> {
        var curr = self
        return AnyGenerator {
            _ -> T? in
            return curr.pop()
        }
    }
}
