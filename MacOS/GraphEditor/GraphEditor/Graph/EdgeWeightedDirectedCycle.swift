//
//  EdgeWeightedDirectedCycle.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 17/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

class EdgeWeightedDirectedCycle<Element: Equatable> {
    
    private var visitedVertices: [Vertex<Element>] = []
    private var destinations: [Destination<Element>] = []
    private var cycleStack: ATStack<Vertex<Element>>?
    private var recursionStack: ATStack<Vertex<Element>> = ATStack()
    
    public var hasCycle: Bool {
        return cycleStack != nil
    }
    
    public var cycle: [Vertex<Element>] {
        return cycleStack?.allElements().reversed() ?? []
    }
    
    init(_ graph: EdgeWeightedDigraph<Element>) {
        
        graph.vertices.forEach { self.destinations.append(Destination($0)) }
        
        graph.vertices.forEach { vertex in
            if self.isVisited(vertex) == false {
                self.depthFirstSearch(vertex)
            }
        }
    }
    
    private func depthFirstSearch(_ vertex: Vertex<Element>) {
        self.recursionStack.push(item: vertex)
        self.visitedVertices.append(vertex)
        
        vertex.adjacentEdges.forEach { (edge) in
            
            let edgeDestination = edge.destination
            let nextDestination = self.destination(for: edgeDestination)
            
            if self.hasCycle {
                return
            } else if self.isVisited(edgeDestination) == false {
                nextDestination.previousVertex = edge.source
                self.depthFirstSearch(edgeDestination)
            } else if self.recursionStack.contains(edgeDestination) == true {
                
                self.cycleStack = ATStack()
                
                self.cycleStack?.push(item: vertex)
                
                var currentDestination = destination(for: vertex)
                while let previousVertex = currentDestination.previousVertex {
                    
                    self.cycleStack?.push(item: previousVertex)
                    
                    if previousVertex == edgeDestination {
                        break
                    }
                    
                    currentDestination = destination(for: previousVertex)
                }
                
                self.cycleStack?.push(item: vertex)
            }
        }
        
        _ = self.recursionStack.pop()
    }
    
    private func isVisited(_ vertex: Vertex<Element>) -> Bool {
        return visitedVertices.contains(vertex)
    }
    
    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
        return destinations.filter { $0.vertex == vertex }.first ?? Destination(vertex)
    }
}
