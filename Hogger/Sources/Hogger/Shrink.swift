//
//  Shrink.swift
//  Hogger
//
//  Created by Michael Shaw on 21/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

struct Shrink {
  // need array shrinking.
}


public func towards<N>(from: N, destination: N) -> [N] where N : Integral {
  if from == destination {
    return []
  } else {
    var h = (destination / 2) - (from / 2)
    var out : [N] = [from]
    while h > 0 {
      let ele = destination - h
      if let last = out.last, last == ele {
        // don't put the same element on twice
      } else {
        out.append(ele)
      }
      h /= 2
    }
    return out
  }
}

// could easily be an iterator instead but ... swift
public func towardsFrac<F>(from: F, destination: F, count: Int) -> [F] where F : Fractional {
  if from == destination {
    return []
  } else {
    var h = (destination / 2.0) - (from / 2.0)
    var out : [F] = [from]
    for _ in 1..<count {
      out.append(destination - h)
      h /= 2.0
    }
    return out
  }
}

