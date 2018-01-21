//
//  Lazy.swift
//  Hogger
//
//  Created by Michael Shaw on 21/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

enum Stream<A> : Sequence {
  case cons(head: A, tail: () -> Stream<A>)
  case empty
  
  func makeIterator() -> StreamIter<A> {
    return StreamIter(stream: self)
  }
}

struct StreamIter<A> : IteratorProtocol {
  var stream : Stream<A>
  
  mutating func next() -> A? {
    switch self.stream {
    case .empty: return nil
    case let .cons(h, tail):
      self.stream = tail()
      return h
    }
  }
}

public class Lazy<A> {
  private var thunk:Thunk<A>
  
  init(thunk:Thunk<A>) {
    self.thunk = thunk
  }
  
  public func force() -> A {
    return thunk.force()
  }
  
  static public func evaluated(_ a:A) -> Lazy<A> {
    return Lazy(thunk: .evaluated(a))
  }
  
  static public func lzy(f: @escaping () -> A) -> Lazy<A> {
    return Lazy(thunk: .unevaluated(f))
  }
}

enum Thunk<A> {
  case unevaluated(() -> A)
  case evaluated(A)
  
  mutating func force() -> A {
    switch self {
    case .evaluated(let a): return a
    case .unevaluated(let f):
      let nv = f()
      self = .evaluated(nv)
      return nv
    }
  }
}
