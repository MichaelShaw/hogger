//
//  TestResult.swift
//  Hogger
//
//  Created by Michael Shaw on 28/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

public enum TestResult {
  case ok
  case failure(reason: String)
}

// should we have a `Testable` protocol, so we can include boolean ...

infix operator === : ComparisonPrecedence
public func === <A>(lhs : A, rhs : A) -> TestResult where A : Equatable {
  if lhs == rhs {
    return TestResult.ok
  } else {
    return TestResult.failure(reason: "\(lhs) was not equal to \(rhs)")
  }
}

infix operator !== : ComparisonPrecedence
public func !== <A>(lhs : A, rhs : A) -> TestResult where A : Equatable {
  if lhs != rhs {
    return TestResult.ok
  } else {
    return TestResult.failure(reason: "\(lhs) was equal to \(rhs)")
  }
}

public func greaterThan<A>(_ lhs: A, _ rhs: A) -> TestResult where A : Comparable {
  if lhs > rhs {
    return .ok
  } else {
    return .failure(reason: "\(lhs) was not greater than \(rhs)")
  }
}

public func lessThan<A>(_ lhs: A, _ rhs: A) -> TestResult where A : Comparable {
  if lhs < rhs {
    return .ok
  } else {
    return .failure(reason: "\(lhs) was not greater than \(rhs)")
  }
}





