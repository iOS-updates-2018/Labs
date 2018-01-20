//
//  QueueTest.swift
//  Test
//
//  Created by Jordan Stapinski on 1/20/18.
//  Copyright © 2018 Jordan Stapinski. All rights reserved.
//

import Foundation
import XCTest

class StackTest: XCTestCase {
  func testEmpty() {
    var stack = Stack<Int>()
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.peek(), nil)
    XCTAssertNil(stack.pop())
  }
  
  func testOneElement() {
    var stack = Stack<Int>()
    
    stack.push(element: 123)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.peek(), 123)
    
    let result = stack.pop()
    XCTAssertEqual(result, 123)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.peek(), nil)
    XCTAssertNil(stack.pop())
  }
  
  func testTwoElements() {
    var stack = Stack<Int>()
    
    stack.push(element: 123)
    stack.push(element: 456)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 2)
    XCTAssertEqual(stack.peek(), 456)
    
    let result1 = stack.pop()
    XCTAssertEqual(result1, 456)
    XCTAssertFalse(stack.isEmpty)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.peek(), 123)
    
    let result2 = stack.pop()
    XCTAssertEqual(result2, 123)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.peek(), nil)
    XCTAssertNil(stack.pop())
  }
  
  func testMakeEmpty() {
    var stack = Stack<Int>()
    
    stack.push(element: 123)
    stack.push(element: 456)
    XCTAssertNotNil(stack.pop())
    XCTAssertNotNil(stack.pop())
    XCTAssertNil(stack.pop())
    
    stack.push(element: 789)
    XCTAssertEqual(stack.count, 1)
    XCTAssertEqual(stack.peek(), 789)
    
    let result = stack.pop()
    XCTAssertEqual(result, 789)
    XCTAssertTrue(stack.isEmpty)
    XCTAssertEqual(stack.count, 0)
    XCTAssertEqual(stack.peek(), nil)
    XCTAssertNil(stack.pop())
  }
}

