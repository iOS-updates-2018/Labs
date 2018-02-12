//
//  BT.swift
//  BinaryTrees
//
//  Created by Jordan Stapinski on 1/29/18.
//

import Foundation

public indirect enum BinaryTree<T> {
  case Node(BinaryTree<T>, T, BinaryTree<T>)
  case Empty
  
  public func count() -> Int {
    // Dynamically updated property: the number of non-empty nodes in the binary tree
    switch self {
    case .Node(let left, _, let right):
      return 1 + left.count() + right.count()
    default:
      return 0
    }
  }
  
  public func traverseInOrder() -> [T] {
    // Returns a list of the objects in the tree in left subtree, current node, right subtree order
    switch self {
    case .Node(let left, let v, let right):
      return (left.traverseInOrder() ) + ([v] as [T]) + (right.traverseInOrder() )
    default:
      return []
    }
    
  }
  
  public func isEmpty() -> Bool {
    // Returns true if this tree is Empty and false otherwise
    // Note that this is a more convenient way than switching on .Empty
    switch self {
    case .Empty:
      return true
    default:
      return false
    }
  }
  
  public func containsValue(t: T) -> T? {
    // Returns an optional with some(t) if t is present in the Binary Tree, and
    // nil otherwise
    return self.traverseInOrder().contains(where: t)
  }
  
}
