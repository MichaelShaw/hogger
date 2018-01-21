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
struct Gen<T> {
  let unGen : (Size, Rng) -> Tree<T>
  
  func map<B>(f: @escaping (T) -> B) -> Gen<B> {
    return Gen<B>(unGen: { (size, rng) -> Tree<B> in
      let treeA = self.unGen(size, rng)
      return treeA.map(f: f)
    })
  }
  
  func flatMap<B>(f: @escaping (T) -> Gen<B>) -> Gen<B> {
    return Gen<B>(unGen: { (size, rng) -> Tree<B> in
      let treeA = self.unGen(size, rng)
      return treeA.flatMap { a -> Tree<B> in
        let genB = f(a)
        return genB.unGen(size, rng)
      }
    })
  }
}
