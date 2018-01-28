//
//  RandomTests.swift
//  HoggerTests
//
//  Created by Michael Shaw on 28/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import XCTest
@testable import Hogger

class RandomTests: XCTestCase {
  func testRandom() {
    let r = XorSource.fromArc()
    for i in 0..<100 {
      let ot = r.nextInt8()
      print(" -> \(ot)")
    }
  }
}

