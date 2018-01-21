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
}

public func map<A,B>(tree:Tree<A>, f: @escaping (A) -> B) -> Tree<B> {
  return Tree(
    val: f(tree.val),
    children: Lazy.lzy {
      let children : [Tree<A>] = tree.children.force()
      return children.map { treeA in map(tree:treeA, f: f) }
    }
  )
}

public func concat<A>(_ prefix:[A], _ suffix:[A]) -> [A] {
  var ot : [A] = []
  ot.append(contentsOf: prefix)
  ot.append(contentsOf: suffix)
  return ot
}

public func flatMap<A, B>(tree:Tree<A>, f: @escaping (A) -> Tree<B>) -> Tree<B> {
  let res : Tree<B> = f(tree.val)
  let nodeB : Tree<B> = Tree(
    val: res.val,
    children: Lazy.lzy { () -> [Tree<B>] in
      let children : [Tree<A>] = tree.children.force()
      var nbs : [Tree<B>] = children.map { (na : Tree<A>) -> Tree<B> in
        return flatMap(tree: na, f: f)
      }
      for c in res.children.force() {
        nbs.append(c)
      }
      return nbs
  })
  return nodeB
}

