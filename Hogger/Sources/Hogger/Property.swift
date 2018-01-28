//
//  Property.swift
//  Hogger
//
//  Created by Michael Shaw on 28/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

public struct CheckerArguments {
  public var maxSuccessful : Int
  public var maxShrinks : Int
  public var seed : Seed?
  
  public func with(successes:Int) -> CheckerArguments {
    var ca = self
    ca.maxSuccessful = successes
    return ca
  }
  
  public func with(seed:Seed) -> CheckerArguments {
    var ca = self
    ca.seed = seed
    return ca
  }
  
  public func noShrinking() -> CheckerArguments {
    var ca = self
    ca.maxShrinks = 0
    return ca
  }
  
  public static let defaultArgs = CheckerArguments(maxSuccessful: 100, maxShrinks: 100, seed: nil)
}

public struct TestContext {
  var name: String
  var args: CheckerArguments
  var file : StaticString
  var line : UInt
  
  public func forall(_ gen: Gen<TestResult>) {
    // we should return some final output?
  }
}

public func callingWorkspace() {
  let ints = Gens.int64(range: Bounds.constant(lower: 0, upper: 100))
  
  // I need my stuff to be more mundane/procedural than other testing frameworks
  // But ... we still need reasonable ergonomics
  property("multiplying by 2 is even").forall(ints.check { n in
    return (n * 2) % 2 === 0
  })
}

// checker args is too cumbersome ... we could do it straight on testcontext
public func property(_ name:String,
                     args: CheckerArguments = CheckerArguments.defaultArgs,
                     file : StaticString = #file,
                     line : UInt = #line) -> TestContext {
  return TestContext(name: name, args: args, file: file, line: line)
}
