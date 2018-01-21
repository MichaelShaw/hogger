//
//  Tree.swift
//  Hogger
//
//  Created by Michael Shaw on 14/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

public func minusTree(n:Int) -> Tree<Int> {
  let shrink : (Int) -> [Int] = { nn in
    var ns  : [Int] = []
    var mn = nn / 2
    while mn >= 1 {
      ns.append(mn)
      mn /= 2
    }
    return ns
  }
  
  return treeFor(a: n, shrink: shrink)
}

public func print<A>(tree:Tree<A>)  { // where A: CustomStringConvertible
  traverse(tree: tree, depth: 0) { (depth, a) in
    let padding = String(repeating: Character(" "), count: depth)
    print("\(padding) -> \(a)")
  }
}

public func traverse<A>(tree:Tree<A>, depth: Int, f:(Int, A) -> ()) {
  f(depth, tree.val)
  for childNode in tree.children.force() {
    traverse(tree: childNode, depth: depth + 1, f: f)
  }
}

public func treeFor<A>(a:A, shrink: @escaping (A) -> [A]) -> Tree<A> {
  return Tree(
    val: a,
    children: Lazy.lzy {
      let cv = shrink(a)
      return cv.map { sa in treeFor(a: sa, shrink: shrink) }
  })
}

public struct Tree<A> { // rename this to tree?
  public var val : A
  public var children: Lazy<[Tree<A>]> // children must be a lazy computation
  
  public static func single(_ a:A) -> Tree<A> {
    return Tree(val: a, children: Lazy.evaluated([]))
  }
  
  public func map<B>(f: @escaping (A) -> B) -> Tree<B> {
    return Tree<B>(
      val: f(self.val),
      children: Lazy.lzy(f: { () -> [Tree<B>] in
        let children : [Tree<A>] = self.children.force()
        let crappo : [Tree<B>] = children.map { treeA in treeA.map(f: f) }
        return crappo
      })
    )
  }
  
  public func flatMap<B>(f: @escaping (A) -> Tree<B>) -> Tree<B> {
    let res : Tree<B> = f(self.val)
    let treeB : Tree<B> = Tree<B>(
      val: res.val,
      children: Lazy.lzy { () -> [Tree<B>] in
        let children : [Tree<A>] = self.children.force()
        var tbs : [Tree<B>] = children.map { (ta : Tree<A>) -> Tree<B> in
          return ta.flatMap(f: f)
        }
        for c in res.children.force() {
          tbs.append(c)
        }
        return tbs
    })
    return treeB
  }
}

