//
//  Queue.swift
//  Test
//
//  Created by Jordan Stapinski on 1/20/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation

public struct Queue<T> {
  public var array = [T]()
  
  public var isEmpty: Bool {
    return array.count == 0
  }
  
  public var count: Int {
    return array.count
  }
  
  public mutating func enqueue(element: T) {
    array.append(element)
  }
  
  public mutating func dequeue() -> T? {
    if (isEmpty){
      return nil
    }
    let firstElement = array[0]
    array.removeFirst()
    return firstElement
  }
  
  public func peek() -> T? {
    if (isEmpty){
      return nil
    }
    return array[0]
  }
}
