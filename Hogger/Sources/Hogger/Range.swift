//
//  Range.swift
//  Hogger
//
//  Created by Michael Shaw on 21/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation


public struct Bounds<A> {
  public let origin : A
  public let extents : (Size) -> (A, A)
  
  public func lowerBound(forSize size: Size) -> A {
    return extents(size).0
  }
  
  public func upperBound(forSize size: Size) -> A {
    return extents(size).1
  }
  
  static func single(a:A) -> Bounds<A> {
    return Bounds(origin: a, extents: { _ in (a, a) })
  }
  
  static func constantFrom(origin: A, lower: A, upper: A) -> Bounds<A> {
    return Bounds(origin: origin, extents: { _ in (lower, upper)})
  }
  
  static func constant(lower: A, upper: A) -> Bounds<A> {
    return constantFrom(origin: lower, lower: lower, upper: upper)
  }
  
  public func map<B>(range: Bounds<A>, f: @escaping (A) -> B) -> Bounds<B> {
    return Bounds<B>(origin: f(range.origin), extents: { size in
      let (l, u) = range.extents(size)
      return (f(l), f(u))
    })
  }
}

public func linear<N>(lower: N, upper : N) -> Bounds<N> where N : Integral {
  return linearFrom(origin: lower, lower: lower, upper: upper)
}

public func linearFrac<F>(lower:F, upper:F) -> Bounds<F> where F : Fractional {
  return linearFracFrom(origin: lower, lower: lower, upper: upper)
}

public func exponential<N>(lower: N, upper : N) -> Bounds<N> where N : Integral {
  return exponentialFrom(origin: lower, lower: lower, upper: upper)
}

public func exponentialFrac<F>(lower: F, upper : F) -> Bounds<F> where F : Fractional {
  return exponentialFracFrom(origin: lower, lower: lower, upper: upper)
}

// only unsigned integers can safely express the (N.max - N.min)
public func linearBounded<N>() -> Bounds<N> where N : Integral & UnsignedInteger {
  return linearFrom(origin: 0, lower: N.min, upper: N.max)
}

public func exponentialBounded<N>() -> Bounds<N> where N : Integral & UnsignedInteger {
  return exponentialFrom(origin: 0, lower: N.min, upper: N.max)
}

public func linearFrom<N>(origin: N, lower:N, upper:N) -> Bounds<N> where N: Integral {
  return Bounds(origin: origin, extents: { size in
    let lowerSized = clamp(scaleLinear(size:size, a: origin, b: lower), lower, upper)
    let upperSized = clamp(scaleLinear(size:size, a: origin, b: upper), lower, upper)
    return (lowerSized, upperSized)
  })
}

public func linearFracFrom<F>(origin: F, lower:F, upper:F) -> Bounds<F> where F: Fractional {
  return Bounds(origin: origin, extents: { size in
    let lowerScaled = clamp(scaleLinearFrac(size: size, a: origin, b: lower), lower, upper)
    let upperScaled = clamp(scaleLinearFrac(size: size, a: origin, b: upper), lower, upper)
    return (lowerScaled, upperScaled)
  })
}

public func exponentialFrom<N>(origin: N, lower: N, upper: N) -> Bounds<N> where N : Integral {
  return Bounds(origin: origin, extents: { size in
    let lowerScaled = clamp(scaleExponential(size: size, a: origin, b: lower), lower, upper)
    let upperScaled = clamp(scaleExponential(size: size, a: origin, b: upper), lower, upper)
    return (lowerScaled, upperScaled)
  })
}

public func exponentialFracFrom<F>(origin: F, lower: F, upper: F) -> Bounds<F> where F : Fractional {
  return Bounds(origin: origin, extents: { size in
    let lowerScaled = clamp(scaleExponentialFrac(size: size, a: origin, b: lower), lower, upper)
    let upperScaled = clamp(scaleExponentialFrac(size: size, a: origin, b: upper), lower, upper)
    return (lowerScaled, upperScaled)
  })
}

public func scaleLinear<N>(size:Size, a:N, b:N) -> N where N : Integral {
  let cSize : Size = clamp(size, 0, 99)
  let diff : N = ((b - a) * N(cSize)) / 99
  return a + diff
}

public func scaleLinearFrac<F>(size:Size, a: F, b: F) -> F where F : Fractional {
  let cSize = clamp(size, 0, 99)
  let diff = ((b - a) * F(cSize)) / 99
  return a + diff
}

public func sigNum<F>(_ f:F) -> F where F : Fractional {
  if f == 0.0 {
    return 0.0
  } else if f > 0.0 {
    return 1.0
  } else {
    return -1.0
  }
}

public func scaleExponential<N>(size:Size, a:N, b:N) -> N where N : Integral {
  let da = Double(exactly: a)!
  let db = Double(exactly: b)!
  let d = scaleExponentialFrac(size: size, a: da, b: db)
  return N(d.rounded(.toNearestOrEven))
}

public func scaleExponentialFrac<F>(size:Size, a:F, b: F) -> F where F : Fractional {
  let cSize = clamp(size, 0, 99)
  let sign = sigNum(b - a)
  
  // pow function isn't defined on general floating point, so we raise to double
  let base : Double = toDouble(abs(b - a)) + 1.0
  let exponent : Double = Double(cSize) / 99.0
  
  return F(pow(base, exponent) - 1.0) * sign
}
