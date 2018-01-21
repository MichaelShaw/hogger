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
    let single = Tree.single(12)
    
    let doubled = single.map { n in n * 2 }
    
//    print("what is doubled -> \(doubled)")
  }
  
  func testTowards() {
    let a = towards(from: 0, destination: 100)
    XCTAssert(a == [0,50,75,88,94,97,99], "towards(0,100) was \(a)")
    let b = towards(from: 500, destination: 1000)
    XCTAssert(b == [500,750,875,938,969,985,993,997,999], "towards(500,1000) was \(b)")
    let c = towards(from: -50, destination: -26)
    XCTAssert(c == [-50,-38,-32,-29,-27], "towards(-50,-26) was \(c)")
  }
  
  func testTowardsFrac() {
    print("test towards frac")
    let a = towardsFrac(from: 0.0, destination: 100.0, count: 7)
    XCTAssert(a.count == 7 && Math.approxEqual(a.last!, 98.4375, epsilon: 0.01), "towards(0.0, 100.0, 7) was \(a)")
    let b = towardsFrac(from: 1.0, destination: 0.5, count: 7)
    XCTAssert(b.count == 7 && Math.approxEqual(b.last!, 0.5078125, epsilon: 0.01), "towards(1.0, 0.5, 7) was \(b)")
  }
  
  func testMinus() {
//    print("test minus :D")
    let mt = minusTree(n:13)
    print(tree: mt)
  }
  
  func testFlatMap() {
//    print("test flatMap")
    let mt = minusTree(n:100)
//
    let someCrap : Tree<(Int, Int)> = mt.flatMap { a in
      minusTree(n: a + 10).flatMap { b in
        return Tree.single((a, b))
      }
    }

    print(tree: someCrap)
  }
}
