//
//  Lazy.swift
//  Hogger
//
//  Created by Michael Shaw on 21/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

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


public class Iter<A> : Sequence, IteratorProtocol { // : IteratorProtocol
  public func next() -> A? { fatalError("LazyIterator is abstract") }
  
}

public class EmptyIter<A> : Iter<A> {
  public override func next() -> A? { return nil }
}

public class ArrayIter<A> : Iter<A> {
  var source : [A]
  var idx : Int
  
  public init(source:[A]) {
    self.source = source
    self.idx = 0
  }
  
  public override func next() -> A? {
    if idx < source.count {
      let ele = source[idx]
      idx += 1
      return ele
    } else {
      return nil
    }
  }
}

public class LazySeq<A> {
  public func iter() -> Iter<A> { fatalError("LazySeq is abstract") }
  public func map<B>(f: @escaping (A) -> B) -> LazySeq<B> {
    return MapSeq(source: self, f: f)
  }
  public func chain(_ other: LazySeq<A>) -> LazySeq<A> {
    return ChainSeq(a: self, b: other)
  }
  public func count() -> Int {
    let it = self.iter()
    var c = 0
    while let _ = it.next() {
      c += 1
    }
    return c
  }
  public func collect() -> [A] {
    let it = self.iter()
    var out : [A] = []
    while let o = it.next() {
      out.append(o)
    }
    return out
  }
}

public class ChainSeq<A> : LazySeq<A> {
  var a : LazySeq<A>
  var b : LazySeq<A>
  
  public init(a: LazySeq<A>, b: LazySeq<A>) {
    self.a = a
    self.b = b
  }
  
  public override func iter() -> Iter<A> {
    return ChainIter(a: a.iter(), b: b.iter())
  }
}

public class ChainIter<A> : Iter<A> {
  var a : Iter<A>
  var b : Iter<A>
  
  var aDepleted : Bool = false
  
  init(a: Iter<A>, b: Iter<A>) {
    self.a = a
    self.b = b
    aDepleted = false
  }
  
  public override func next() -> A? {
    if !aDepleted {
      if let r = self.a.next() {
        return r
      } else {
        aDepleted = true
      }
    }
    return b.next()
  }
}

public class MapSeq<A, B> : LazySeq<B> {
  let source : LazySeq<A>
  let f : (A) -> B
  
  public init(source: LazySeq<A>, f: @escaping (A) -> B) {
    self.source = source
    self.f = f
  }
  
  public override func iter() -> Iter<B> {
    return MapIter(source: source.iter(), f: f)
  }
}

public class EmptySeq<A> : LazySeq<A> {
  public override func iter() -> Iter<A> {
    return EmptyIter()
  }
}

public class LazySeqF<A> : LazySeq<A> {
  var f : () -> Iter<A>
  public init(f: @escaping () -> Iter<A>) {
    self.f = f
  }
  
  public override func iter() -> Iter<A> {
    return f()
  }
}

public class MapIter<A, B> : Iter<B> {
  var source : Iter<A>
  var f : (A) -> B
  
  public init(source: Iter<A>, f: @escaping (A) -> B) {
    self.source = source
    self.f = f
  }
  
  public override func next() -> B? {
    return self.source.next().map(self.f)
  }
}

public class IntegerIterator<A> : Iter<A> where A : Integral {
  let from: A
  let to: A
  var current: A
  
  public init(from: A, to:A) {
    self.from = from
    self.to = to
    self.current = from
  }
  
  public override func next() -> A? {
    if self.current < to {
      let n = self.current
      self.current += 1
      return n
    } else {
      return nil
    }
  }
}
