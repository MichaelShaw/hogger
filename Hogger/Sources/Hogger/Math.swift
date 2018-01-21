//
//  Math.swift
//  Genmai
//
//  Created by Michael Shaw on 23/8/17.
//  Copyright © 2017 Cosmic Teapot. All rights reserved.
//

import Foundation


public typealias Integral = BinaryInteger & FixedWidthInteger
public typealias Fractional = BinaryFloatingPoint

public func toDouble<F>(_ f:F) -> Double where F : Fractional {
  if let ff = f as? Float {
    return Double(ff)
  } else {
    return f as! Double
  }
}

public struct Math {
  public static func approxEqual<F>(_ lhs:F, _ rhs: F, epsilon:F) -> Bool where F : Fractional {
    return abs(lhs - rhs) < epsilon
  }
  
  public static func modulusWithoutSign(_ a:Int, n:Int) -> Int {
    return (a % (n + n)) % n
  }
  
  public static func modulusWithoutSign(_ a:Int64, n:Int64) -> Int64 {
    return (a % (n + n)) % n
  }
  
  public static func modulusWithoutSign(_ a:Int32, n:Int32) -> Int32 {
    return (a % (n + n)) % n
  }

  public static func modulusWithoutSign(_ a:UInt, n:UInt) -> UInt {
    return (a % (n + n)) % n
  }
  
  public static func modulusWithoutSign(_ a:Double, n:Double) -> Double {
    return a.truncatingRemainder(dividingBy: n)
  }
  
  public static func rounded3(_ d:Double) -> String {
    return String(format: "%.3f", d)
  }
}

public func concat<A>(_ prefix:[A], _ suffix:[A]) -> [A] {
  var ot : [A] = []
  ot.append(contentsOf: prefix)
  ot.append(contentsOf: suffix)
  return ot
}

// running `map` on a int gen, might negate things, reversing the range
// so we use a slightly more careufl clamp
func clamp<T>(_ t:T, _ lo:T, _ hi:T) -> T where T : Comparable {
  if lo > hi {
    return min(lo, max(t, hi))
  } else {
    return min(hi, max(t, lo))
  }
}
