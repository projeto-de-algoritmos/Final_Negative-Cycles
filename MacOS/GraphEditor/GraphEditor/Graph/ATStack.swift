//
//  ATStack.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 17/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

public class ATStack<Element: Equatable> {
    
    class Node<Element> {
        var item: Element
        var next: Node?
        
        init(withItem item: Element) {
            self.item = item
        }
    }
    
    private var head: Node<Element>?
    private var count: Int = 0
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var size: Int {
        return count
    }
    
    public func push(item: Element) {
        let oldHead = head
        head = Node(withItem: item)
        head?.next = oldHead
        count += 1
    }
    
    public func pop() -> Element? {
        let item = head?.item
        head = head?.next
        count -= 1
        return item
    }
    
    public func peek() -> Element? {
        return head?.item
    }
    
    public func contains(_ element: Element) -> Bool {
        var current = head
        while (current != nil) {
            if current?.item == element {
                return true
            }
            current = current?.next
        }
        return false
    }
    
    public func allElements() -> [Element] {
        var result: [Element] = []
        
        var current = head
        while current != nil {
            result.append(current!.item)
            current = current?.next
        }
        
        return result
    }
}
