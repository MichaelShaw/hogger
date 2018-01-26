//
//  ShrinkTests.swift
//  HoggerTests
//
//  Created by Michael Shaw on 26/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import XCTest
@testable import Hogger

class ShrinkTests: XCTestCase {
  func testTowards() {
    let a = Towards(from: 0, destination: 100)
    XCTAssert(a.collect() == [0,50,75,88,94,97,99], "towards(0,100) was \(a)")
    let b = Towards(from: 500, destination: 1000)
    XCTAssert(b.collect() == [500,750,875,938,969,985,993,997,999], "towards(500,1000) was \(b)")
    let c = Towards(from: -50, destination: -26)
    XCTAssert(c.collect() == [-50,-38,-32,-29,-27], "towards(-50,-26) was \(c)")
  }
  
  func testTowardsFrac() {
    let a = Array(TowardsFrac(from: 0.0, destination: 100.0).iter().prefix(7))
    XCTAssert(a.count == 7 && Math.approxEqual(a.last!, 98.4375, epsilon: 0.01), "towards(0.0, 100.0, 7) was \(a)")
    let b = Array(TowardsFrac(from: 1.0, destination: 0.5).iter().prefix(7))
    XCTAssert(b.count == 7 && Math.approxEqual(b.last!, 0.5078125, epsilon: 0.01), "towards(1.0, 0.5, 7) was \(b)")
  }

}
