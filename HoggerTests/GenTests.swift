//
//  GenTests.swift
//  HoggerTests
//
//  Created by Michael Shaw on 26/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import XCTest
@testable import Hogger

class GenTests: XCTestCase {
  func testInt() {
    let bounds : Bounds<Int> = linear(lower: 1, upper: 20)
    
    let gen = Gens.integral(range: bounds)

    let rng = XorSource.iteratedTimeBased()

    let tree = gen.unGen(30, rng)
    print("what is value of tree -> \(tree.val)")
    print(tree: tree)
  }
}
