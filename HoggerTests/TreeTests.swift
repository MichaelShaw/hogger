//
//  LazyTests.swift
//  HoggerTests
//
//  Created by Michael Shaw on 26/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import XCTest
@testable import Hogger

class TreeTests: XCTestCase {
  func testRanger() {
    print("Testing ranger")
    let range = LazySeqF { IntegerIterator(from: 10, to: 15) }
    for n in range.iter() {
      print("n -> \(n)")
    }
  }
  
  func testTree() {
    let tree = halvingTree(n: 13)
    print(tree: tree)
  }
  
  func testTreeMap() {
    let tree = halvingTree(n: 13)
    let doubleTree = tree.map { n in n * 2 }
    print("== double tree ==")
    print(tree:doubleTree)
  }
  
  func testTreeFlatMap() {
    let mt = halvingTree(n:100)
    
    let pairTree : Tree<(Int, Int)> = mt.flatMap { a in
      return halvingTree(n: a + 10).map { b in (a, b) }
    }
    
    print(tree: pairTree)
  }
}
