//
//  Bounded.swift
//  Hogger
//
//  Created by Michael Shaw on 28/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

protocol Bounded {
  static var minBound : Self { get }
  static var maxBound : Self { get }
  
  // count between a and b, produce Nth?
}

extension Bool : Bounded {
  public static var minBound : Bool {
    return false
  }
  
  public static var maxBound : Bool {
    return true
  }
}

extension Character : Bounded {
  public static var minBound : Character {
    return "\0"
  }
  
  public static var maxBound : Character {
    return "\u{FFFFF}"
  }
}

extension UInt : Bounded {
  public static var minBound : UInt {
    return UInt.min
  }
  
  public static var maxBound : UInt {
    return UInt.max
  }
}

extension UInt8 : Bounded {
  public static var minBound : UInt8 {
    return UInt8.min
  }
  
  public static var maxBound : UInt8 {
    return UInt8.max
  }
}

extension UInt16 : Bounded {
  public static var minBound : UInt16 {
    return UInt16.min
  }
  
  public static var maxBound : UInt16 {
    return UInt16.max
  }
}


extension UInt32 : Bounded {
  public static var minBound : UInt32 {
    return UInt32.min
  }
  
  public static var maxBound : UInt32 {
    return UInt32.max
  }
}


extension UInt64 : Bounded {
  public static var minBound : UInt64 {
    return UInt64.min
  }
  
  public static var maxBound : UInt64 {
    return UInt64.max
  }
}

extension Int : Bounded {
  public static var minBound : Int {
    return Int.min
  }
  
  public static var maxBound : Int {
    return Int.max
  }
}

extension Int8 : Bounded {
  public static var minBound : Int8 {
    return Int8.min
  }
  
  public static var maxBound : Int8 {
    return Int8.max
  }
}

extension Int16 : Bounded {
  public static var minBound : Int16 {
    return Int16.min
  }
  
  public static var maxBound : Int16 {
    return Int16.max
  }
}


extension Int32 : Bounded {
  public static var minBound : Int32 {
    return Int32.min
  }
  
  public static var maxBound : Int32 {
    return Int32.max
  }
}


extension Int64 : Bounded {
  public static var minBound : Int64 {
    return Int64.min
  }
  
  public static var maxBound : Int64 {
    return Int64.max
  }
}

extension Float : Bounded {
  public static var minBound : Float {
    return Float.leastNormalMagnitude
  }
  
  public static var maxBound : Float {
    return Float.greatestFiniteMagnitude
  }
}

extension Double : Bounded {
  public static var minBound : Double {
    return Double.leastNormalMagnitude
  }
  
  public static var maxBound : Double {
    return Double.greatestFiniteMagnitude
  }
}
