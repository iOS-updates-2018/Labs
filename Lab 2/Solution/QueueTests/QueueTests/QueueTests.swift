//
//  QueueTests.swift
//  QueueTests
//
//  Created by Jordan Stapinski on 1/20/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
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
    
    queue.enqueue(element: 123)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek(), 123)
    
    let result = queue.dequeue()
    XCTAssertEqual(result, 123)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertEqual(queue.peek(), nil)
    XCTAssertNil(queue.dequeue())
  }
  
  func testTwoElements() {
    var queue = Queue<Int>()
    
    queue.enqueue(element: 123)
    queue.enqueue(element: 456)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 2)
    XCTAssertEqual(queue.peek(), 123)
    
    let result1 = queue.dequeue()
    XCTAssertEqual(result1, 123)
    XCTAssertFalse(queue.isEmpty)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek(), 456)
    
    let result2 = queue.dequeue()
    XCTAssertEqual(result2, 456)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertEqual(queue.peek(), nil)
    XCTAssertNil(queue.dequeue())
  }
  
  func testMakeEmpty() {
    var queue = Queue<Int>()
    
    queue.enqueue(element: 123)
    queue.enqueue(element: 456)
    XCTAssertNotNil(queue.dequeue())
    XCTAssertNotNil(queue.dequeue())
    XCTAssertNil(queue.dequeue())
    
    queue.enqueue(element: 789)
    XCTAssertEqual(queue.count, 1)
    XCTAssertEqual(queue.peek(), 789)
    
    let result = queue.dequeue()
    XCTAssertEqual(result, 789)
    XCTAssertTrue(queue.isEmpty)
    XCTAssertEqual(queue.count, 0)
    XCTAssertEqual(queue.peek(), nil)
    XCTAssertNil(queue.dequeue())
  }
    
}
