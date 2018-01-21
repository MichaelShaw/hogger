//
//  Tree.swift
//  Hogger
//
//  Created by Michael Shaw on 14/1/18.
//  Copyright © 2018 Michael Shaw. All rights reserved.
//

public func minusTree(n:Int) -> Node<Int> {
  let shrink : (Int) -> [Int] = { nn in
    var ns  : [Int] = []
    var mn = nn / 2
    while mn >= 1 {
      ns.append(mn)
      mn /= 2
    }
    return ns
  }
  
  return nodeFor(a: n, shrink: shrink)
}

public func print<A>(node:Node<A>)  { // where A: CustomStringConvertible
  traverse(node: node, depth: 0) { (depth, a) in
    let padding = String(repeating: Character(" "), count: depth)
    print("\(padding) -> \(a)")
  }
}

public func traverse<A>(node:Node<A>, depth: Int, f:(Int, A) -> ()) {
  f(depth, node.val)
  for childNode in node.children.force() {
    traverse(node: childNode, depth: depth + 1, f: f)
  }
}

public func nodeFor<A>(a:A, shrink: @escaping (A) -> [A]) -> Node<A> {
  return Node(
    val: a,
    children: Lazy.lzy {
      let cv = shrink(a)
      return cv.map { sa in nodeFor(a: sa, shrink: shrink) }
  })
}

public struct Node<A> { // rename this to tree?
  public var val : A
  public var children: Lazy<[Node<A>]> // children must be a lazy computation
  
  public static func single(_ a:A) -> Node<A> {
    return Node(val: a, children: Lazy.evaluated([]))
  }
}

public func map<A,B>(node:Node<A>, f: @escaping (A) -> B) -> Node<B> {
  return Node(
    val: f(node.val),
    children: Lazy.lzy {
      let nodes : [Node<A>] = node.children.force()
      return nodes.map { nodeA in map(node:nodeA, f: f) }
    }
  )
}

public func concat<A>(_ prefix:[A], _ suffix:[A]) -> [A] {
  var ot : [A] = []
  ot.append(contentsOf: prefix)
  ot.append(contentsOf: suffix)
  return ot
}

public func flatMap<A, B>(node:Node<A>, f: @escaping (A) -> Node<B>) -> Node<B> {
  let res : Node<B> = f(node.val)
  let nodeB : Node<B> = Node(
    val: res.val,
    children: Lazy.lzy { () -> [Node<B>] in
      let children : [Node<A>] = node.children.force()
      var nbs : [Node<B>] = children.map { (na : Node<A>) -> Node<B> in
        return flatMap(node: na, f: f)
      }
      for c in res.children.force() {
        nbs.append(c)
      }
      return nbs
  })
  return nodeB
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
