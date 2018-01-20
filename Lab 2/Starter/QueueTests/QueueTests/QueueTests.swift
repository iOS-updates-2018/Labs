//
//  QueueTests.swift
//  QueueTests
//

import XCTest

class QueueTests: XCTestCase {
  
  func testEmpty() {
    var queue = Queue<Int>()
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertEqual(queue.peek(), nil)
    XCTAssertNil(queue.dequeue())
  }
  
  func testOneElement() {
    var queue = Queue<Int>()
//  Should test queue properties with one element
  }
  
  func testTwoElements() {
    var queue = Queue<Int>()
//  Should test queue properties with multiple elements
  }
  
  func testMakeEmpty() {
    var queue = Queue<Int>()
//  Should test enqueue/dequeue with an empty queue
  }
  
}

