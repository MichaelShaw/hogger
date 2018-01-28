//
//  Gen.swift
//  Hogger
//
//  Created by Michael Shaw on 14/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

public typealias Size = Int
typealias Rng = Random

// should we make our generators fallible? (so we can define filter?)
// this is a shrinking gen
// if we want some zero overhead stuff, we want a gen that does not emit a tree
public struct Gen<T> {
  let unGen : (Size, Rng) -> Tree<T>
  
  func map<B>(f: @escaping (T) -> B) -> Gen<B> {
    return Gen<B>(unGen: { (size, rng) -> Tree<B> in
      let treeA = self.unGen(size, rng)
      return treeA.map(f: f)
    })
  }
  
  public func flatMap<B>(f: @escaping (T) -> Gen<B>) -> Gen<B> {
    return Gen<B>(unGen: { (size, rng) -> Tree<B> in
      let treeA = self.unGen(size, rng)
      return treeA.flatMap { a -> Tree<B> in
        let genB = f(a)
        return genB.unGen(size, rng)
      }
    })
  }
  
  // this is just a convenience for map to test resutl
  public func check(f: @escaping (T) -> TestResult) -> Gen<TestResult> {
    return Gen<TestResult>(unGen: { (size, rng) -> Tree<TestResult> in
      let treeA = self.unGen(size, rng)
      return treeA.map(f: f)
    })
  }
}

public struct Gens {
  public static func int8(range: Bounds<Int8>) -> Gen<Int8> {
    return integral(range: range)
  }
  
  public static func int16(range: Bounds<Int16>) -> Gen<Int16> {
    return integral(range: range)
  }
  
  public static func int32(range: Bounds<Int32>) -> Gen<Int32> {
    return integral(range: range)
  }
  
  public static func int64(range: Bounds<Int64>) -> Gen<Int64> {
    return integral(range: range)
  }
  
  public static func uint8(range: Bounds<UInt8>) -> Gen<UInt8> {
    return integral(range: range)
  }
  
  public static func uint16(range: Bounds<UInt16>) -> Gen<UInt16> {
    return integral(range: range)
  }
  
  public static func uint32(range: Bounds<UInt32>) -> Gen<UInt32> {
    return integral(range: range)
  }
  
  public static func uint64(range: Bounds<UInt64>) -> Gen<UInt64> {
    return integral(range: range)
  }
  
  public static func fractional<F>(range: Bounds<F>) -> Gen<F> where F : Fractional {
    return Gen<F> { (size, rng) in
      let (l, h) = range.extents(size)
      let d = rng.nextDouble(toDouble(l), toDouble(h))
      let fd = F(d)
      return treeFor(a: fd, shrink: { f in
        return TowardsFrac<F>(from: range.origin, destination: f)
      })
    }
  }
  
  public static func integral<N>(range: Bounds<N>) -> Gen<N> where N : Integral {
    return Gen<N> { (size, rng) in
      let (l, h) = range.extents(size)
      let n = rng.nextIntegral(l: l, h: h)
      return treeFor(a: n, shrink: { n in
        return Towards<N>(from: range.origin, destination: n)
      })
    }
  }
}
