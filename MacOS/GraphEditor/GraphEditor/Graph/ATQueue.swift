//
//  ATQueue.swift
//  ATQueue
//
//  Created by Dejan on 14/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

class ATQueue<Element: Equatable> {
    
    private class Node<Element: Equatable> {
        
        let value: Element
        var previous: Node?
        var next: Node?
        
        init(_ value: Element) {
            self.value = value
        }
    }
    
    private var head: Node<Element>?
    private var tail: Node<Element>?
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public var size: Int {
        var count = 0
        var current = head
        while (current != nil) {
            current = current?.next
            count += 1
        }
        return count
    }
    
    public var elements: [Element] {
        get {
            var result: [Element] = []
            
            var current = head
            while let node = current {
                result.append(node.value)
                current = node.next
            }
            
            return result
        }
    }
    
    public var reversedElements: [Element] {
        get {
            var result: [Element] = []
            
            var current = tail
            while let node = current {
                result.append(node.value)
                current = node.previous
            }
            
            return result
        }
    }
    
    public func enqueue(_ element: Element) {
        guard contains(element) == false else {
            return
        }
        
        let newNode = Node(element)
        tail?.next = newNode
        newNode.previous = tail
        
        tail = newNode
        
        if head == nil {
            head = tail
        }
    }
    
    public func dequeue() -> Element? {
        let element = head
        
        head = element?.next
        
        if head == nil {
            tail = nil
        }
        
        return element?.value
    }
    
    public func contains(_ element: Element) -> Bool {
        var current = head
        while (current != nil) {
            if current?.value == element {
                return true
            }
            current = current?.next
        }
        return false
    }
    
    
}
