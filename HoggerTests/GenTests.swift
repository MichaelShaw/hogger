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
  func testFracShrinking() {
    let frac = TowardsFrac(from: Float(0.0), destination: Float(100.0))
    let count = frac.count()
    print("took -> \(count) steps")
    for f in frac.iter() {
      print(" -> \(f)")
    }
  }
  
  func testIntegral() {
    let gen = Gens.integral(range: linear(lower: 1, upper: 200))
    let rng = XorSource.iteratedTimeBased()
    let tree = gen.unGen(30, rng)
    print(tree: tree)
  }
  
  func testFractional() {
    let gen : Gen<Double> = Gens.fractional(range: linearFrac(lower: 1.1, upper: 20.9))
    let rng = XorSource.iteratedTimeBased()
    let tree = gen.unGen(30, rng)
    print(tree: tree)
  }
}
