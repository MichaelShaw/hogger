//
//  LazyTree.swift
//  Hogger
//
//  Created by Michael Shaw on 26/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

import Foundation

public struct Tree<A> {
  public var val : A
  public var children : LazySeq<Tree<A>>
  
  public func map<B>(f: @escaping (A) -> B) -> Tree<B> {
    return Tree<B>(
      val: f(self.val),
      children:self.children.map { ele in
        return ele.map(f: f)
      }
    )
  }
  
  public func flatMap<B>(f: @escaping (A) -> Tree<B>) -> Tree<B> {
    let res : Tree<B> = f(self.val)
    let myChildren = self.children.map { ta in ta.flatMap(f: f)}
    
    return Tree<B>(
      val: res.val,
      children: myChildren.chain(res.children)
    )
  }
  
  public static func single(_ a:A) -> Tree<A> {
    return Tree(
      val: a,
      children: LazySeqF { EmptyIter() }
    )
  }
}

public class HalvingIter : Iter<Int> {
  var v : Int
  
  public init(v: Int) {
    self.v = v
  }
  
  public override func next() -> Int? {
    self.v /= 2
    if v >= 1 {
      return v
    } else {
      return nil
    }
  }
}

public func halvingTree(n:Int) -> Tree<Int> {
  return treeFor(a: n) { ele in
    return LazySeqF { HalvingIter(v: ele) }
  }
}

public func traverse<A>(tree:Tree<A>, depth: Int, f:(Int, A) -> ()) {
  f(depth, tree.val)
  for childTree in tree.children.iter() {
    traverse(tree: childTree, depth: depth + 1, f: f)
  }
}

public func print<A>(tree:Tree<A>)  { // where A: CustomStringConvertible
  traverse(tree: tree, depth: 0) { (depth, a) in
    let padding = String(repeating: Character(" "), count: depth)
    print("\(padding) -> \(a)")
  }
}

public func treeFor<A>(a:A, shrink: @escaping (A) -> LazySeq<A>) -> Tree<A> {
  let children = shrink(a).map { a in
    return treeFor(a: a, shrink: shrink)
  }
  return Tree(
    val: a,
    children: children
  )
}
