//
//  Random.swift
//  Genmai
//
//  Created by Michael Shaw on 23/8/17.
//  Copyright © 2017 Cosmic Teapot. All rights reserved.
//

extension MutableCollection {
  /// Shuffles the contents of this collection.
  mutating func shuffleInPlace(_ rng:Random) {
    let c = count
    guard c > 1 else { return }
    
    for (unshuffledCount, firstUnshuffled) in zip(stride(from: c, to: 1, by: -1), indices) {
      let d: IndexDistance = numericCast(rng.nextPositiveInt(numericCast(unshuffledCount) - 1))
      guard d != 0 else { continue }
      let i = index(firstUnshuffled, offsetBy: d)
      self.swapAt(firstUnshuffled, i)
    }
  }
}

protocol RandomSource : CustomStringConvertible {
  func nextUInt32() -> UInt32
}

public final class XorSource : RandomSource {
  var w : UInt32
  var x : UInt32
  var y : UInt32
  var z : UInt32
  
  public init(w: UInt32, x:UInt32, y:UInt32, z:UInt32) {
    self.w = w
    self.x = x
    self.y = y
    self.z = z
  }
  
  public init(seed:Seed) {
    self.w = seed.w
    self.x = seed.x
    self.y = seed.y
    self.z = seed.z
  }
  
  public func nextUInt32() -> UInt32 {
    let x = self.x;
    let t = x ^ (x << 11);
    self.x = self.y;
    self.y = self.z;
    self.z = self.w;
    let w_ = self.w;
    self.w = w_ ^ (w_ >> 19) ^ (t ^ (t >> 8));
    return self.w
  }
  
  public var description : String {
    return "XorSource(w:\(w), x:\(x), y:\(y), z:\(z))"
  }
  
  public static func fromArc() -> Random {
    let seed = Seed.fromArc()
    return Random(source: XorSource(seed: seed))
  }
}


public struct Seed {
  var w: UInt32
  var x: UInt32
  var y: UInt32
  var z: UInt32
  
  public static func fromArc() -> Seed {
    let w = arc4random()
    let x = arc4random()
    let y = arc4random()
    let z = arc4random()
    return Seed(w: w, x: x, y: y, z: z)
  }
}

public final class Random : CustomStringConvertible {
  let source:XorSource
  
  init(source:XorSource) {
    self.source = source
  }
  
  public func nextUInt8() -> UInt8 {
    return UInt8(truncatingIfNeeded: source.nextUInt32())
  }
  
  public func nextUInt32() -> UInt32 {
    return source.nextUInt32()
  }
  
  public func nextUInt64() -> UInt64 {
    return (UInt64(source.nextUInt32()) << 32) | UInt64(source.nextUInt32())
  }
  
  public func nextInt8() -> Int8 {
    return Int8(truncatingIfNeeded: source.nextUInt32())
  }
  
  public func nextInt32() -> Int32 {
    return Int32(bitPattern: source.nextUInt32())
  }
  
  public func nextInt64() -> Int64 {
    return Int64(bitPattern: nextUInt64())
  }
  
  public func nextPositiveInt32() -> Int32 {
    return abs(nextInt32())
  }
  
  public func nextPositiveInt64() -> Int64 {
    return abs(nextInt64())
  }
  
  public func nextUInt() -> UInt {
    return UInt(truncatingIfNeeded: nextUInt64())
  }
  
  public func nextInt() -> Int {
    return Int(bitPattern: nextUInt())
  }
  
  public var description : String {
    return "FastRng(\(source))"
  }
  
  public func nextPositiveInt() -> Int {
    return abs(nextInt())
  }
  
  public func nextPositiveInt(_ upperBound:Int) -> Int {
    if upperBound == 0 {
      return 0
    } else {
      return Math.modulusWithoutSign(nextPositiveInt(), n: Int(upperBound )) // inclusive
    }
  }
  
  public func nextPositiveInt64(_ upperBound:Int64) -> Int64 {
    if upperBound == 0 {
      return 0
    } else {
      return Math.modulusWithoutSign(nextPositiveInt64(), n: Int64(upperBound)) // inclusive
    }
  }
  
  public func nextPositiveInt32(_ upperBound:Int32) -> Int32 {
    if upperBound == 0 {
      return 0
    } else {
      return Math.modulusWithoutSign(nextPositiveInt32(), n: Int32(upperBound)) // inclusive
    }
  }
  
  public func nextMap<T>(l:Int64, h:Int64, f: (Random) -> T) -> [T] {
    var eles : [T] = []
    
    let count = self.nextInt64(l: l, h: h)
    for _ in 0..<count { // we do inclusive
      eles.append(f(self))
    }
    return eles
  }
  
  public func nextInt32(l: Int32, h:Int32) -> Int32 {
    if l == h {
      return l
    } else if l > h {
      return nextInt32(l: h, h: l)
    } else {
      let rangeSize = h - l
      return l + Math.modulusWithoutSign(nextPositiveInt32(), n:rangeSize)
    }
  }
  
  public func nextInt(l: Int, h:Int) -> Int {
    if l == h {
      return l
    } else if l > h {
      return nextInt(l: h, h: l)
    } else {
      let rangeSize = h - l
      return l + Math.modulusWithoutSign(nextPositiveInt(), n:rangeSize)
    }
  }
  
  public func nextIntegral<N>() -> N where N : Integral {
    let uint = self.nextUInt64()
    return N(truncatingIfNeeded: uint) // is horribly wrong
  }
  
  public func nextIntegral<N>(l: N, h: N) -> N where N : Integral {
    if l == h {
      return l
    } else if l > h {
      return nextIntegral(l: h, h: l)
    } else {
      let rangeSize = UInt64(h - l)
      let ni : UInt64 = nextUInt64()
      return l + N(Math.modulusIntWithoutSign(ni, n:rangeSize))
    }
  }
  
  public func nextInt64(l: Int64, h:Int64) -> Int64 {
    if l == h {
      return l
    } else if l > h {
      return nextInt64(l: h, h: l)
    } else {
      let rangeSize = h - l
      return l + Math.modulusWithoutSign(nextPositiveInt64(), n:rangeSize)
    }
  }
  
  public func nextBool() -> Bool {
    return nextPositiveInt(2) == 0
  }
  
  public func nextShuffle<T>(_ t:[T]) -> [T] {
    var arr = Array(t)
    arr.shuffleInPlace(self)
    return arr
  }
  
  public func nextDouble() -> Double {
    let upperMask = UInt64(0x3FF0000000000000 as UInt64)
    let lowerMask = UInt64(0xFFFFFFFFFFFFF as UInt64)
    let tmp = upperMask | (nextUInt64() & lowerMask)
    let result = Double(bitPattern: tmp)
    return result - 1.0
  }
  
  public func nextPositiveDouble(_ upper:Double) -> Double {
    return upper * nextDouble()
  }
  
  public func nextDouble(_ l:Double, _ h:Double) -> Double {
    if l == h {
      return l
    } else if l > h {
      return nextDouble(h, l)
    } else {
      let rangeSize = h - l
      return l + Math.modulusWithoutSign(nextPositiveDouble(rangeSize), n:rangeSize)
    }
  }
  
  public func nextChoice<T>(_ t:[T]) -> T? {
    if t.isEmpty {
      return nil
    } else {
      return t[nextPositiveInt(t.count - 1)]
    }
  }
  
  public func nextChooseSome<T>(_ t:[T]) -> [T] {
    return t.filter { _ in self.nextBool() }
  }
  
  public func nextUUID() -> UUID {
    let raw: uuid_t = (self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),
                       self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),
                       self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),
                       self.nextUInt8(),self.nextUInt8(),self.nextUInt8(),self.nextUInt8())
    return UUID(uuid: raw)
  }
}
