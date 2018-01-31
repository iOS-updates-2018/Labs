//
//  BinaryTreeTests.swift
//  BinaryTrees
//
//  Created by Jordan Stapinski on 1/29/18.
//

import XCTest

class BinaryTreeTests: XCTestCase {
  
  var emptyTree = BinaryTree<Int>.Empty

  func testCount(){
    XCTAssertEqual(emptyTree.count(), 0)
  }
  
  func testTraverseInOrder(){
    XCTAssertEqual(emptyTree.traverseInOrder(), [])
  }
  
  func testIsEmpty(){
    XCTAssert(emptyTree.isEmpty())
  }
  
  func testContainsValue(){
    XCTAssert((emptyTree.containsValue(t: 0)) == nil)
  }

}
