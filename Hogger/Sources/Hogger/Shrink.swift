//
//  Shrink.swift
//  Hogger
//
//  Created by Michael Shaw on 21/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

public class Towards<N> : LazySeq<N> where N : Integral {
  var from : N
  var destination : N
  
  init(from : N, destination : N) {
    self.from = from
    self.destination = destination
  }
  
  public override func iter() -> Iter<N> {
    return TowardsIter(from: from, destination: destination)
  }
}

public class TowardsIter<N> : Iter<N> where N : Integral {
  var h : N
  var destination : N
  var current : N?
 
  public init(from: N, destination: N) {
    self.destination = destination
    self.current = from
    self.h = (destination / 2) - (from / 2)
  }
  
  public override func next() -> N? {
    let c = self.current
    
    if h > 0 {
      let ele = destination - h
      if ele == c {
        self.current = nil
      } else {
        self.current = ele
      }
    } else {
      self.current = nil
    }
    
    self.h /= 2
    
    return c
  }
}

public class TowardsFrac<F> : LazySeq<F> where F : Fractional {
  var from : F
  var destination : F
  
  public init(from : F, destination : F) {
    self.from = from
    self.destination = destination
  }
  
  public override func iter() -> Iter<F> {
    return TowardsFracIter(from: from, destination: destination)
  }
}

public class TowardsFracIter<F> : Iter<F> where F : Fractional {
  var h : F
  var destination : F
  var current : F

  public init(from: F, destination : F) {
    self.h = (destination / 2.0) - (from / 2.0)
    self.destination = destination
    self.current = from
  }
  
  public override func next() -> F? {
    let c = self.current
    self.current = destination - h
    h /= 2.0
    return c
  }
}


