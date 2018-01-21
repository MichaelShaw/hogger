//
//  HoggerTests.swift
//  HoggerTests
//
//  Created by Michael Shaw on 14/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import XCTest
@testable import Hogger

class HoggerTests: XCTestCase {
  func testTree() {
    // This is an example of a functional test case.
      // Use XCTAssert and related functions to verify your tests produce the correct results.
    let single = Node.single(12)
    
    let doubled = map(node: single) { n in n * 2 }
    
    print("what is doubled -> \(doubled)")
  }
  
  func testMinus() {
    print("test minus :D")
    let mt = minusTree(n:13)
    print(node: mt)
  }
  
  func testFlatMap() {
    print("test flatMap")
    let mt = minusTree(n:100)
//
    let someCrap : Node<(Int, Int)> = flatMap(node: mt) { a in
      flatMap(node: minusTree(n: a + 10)) { b in
        return Node.single((a, b))
      }
    }

    print(node: someCrap)
  }
}
