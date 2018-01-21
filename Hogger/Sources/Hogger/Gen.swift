//
//  Gen.swift
//  Hogger
//
//  Created by Michael Shaw on 14/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

public typealias Size = Int
typealias Rng = Random

// should we make our iterators fallible?
struct Gen<T> {
  let unGen : (Size, Rng) -> Tree<T>
}

func map<A, B>(gen: Gen<A>, f: @escaping (A) -> B) -> Gen<B> {
  return Gen(unGen: { (size, rng) -> Tree<B> in
    let nodeA = gen.unGen(size, rng)
    return map(tree: nodeA, f: f)
  })
}

func flatMap<A, B>(gen: Gen<A>, f: @escaping (A) -> Gen<B>) -> Gen<B> {
  return Gen(unGen: { (size, rng) -> Tree<B> in
    let nodeA = gen.unGen(size, rng)
    return flatMap(tree: nodeA) { a -> Tree<B> in
      let genB = f(a)
      return genB.unGen(size, rng)
    }
  })
}
