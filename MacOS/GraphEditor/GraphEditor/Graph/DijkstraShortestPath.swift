//
//  DijkstraShortestPath.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 01/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

class DijkstraShortestPath<Element: Equatable> {
    
    private var destinations: [Destination<Element>] = [] // Dictionary would be more efficient. Using array for simplicity.
    private var priorityQueue: SimplePriorityQueue<Vertex<Element>> = SimplePriorityQueue<Vertex<Element>>()
    
    init(_ graph: EdgeWeightedDigraph<Element>, source: Vertex<Element>) {
        
        graph.vertices.forEach { self.destinations.append(Destination($0)) }
        
        let sourceDestination = destination(for: source)
        sourceDestination.totalWeight = 0.0
        
        priorityQueue.insert(source, priority: 0.0)
        
        while (priorityQueue.isEmpty == false) {
            if let min = priorityQueue.deleteMin() {
                relax(min)
            }
        }
    }
    
    private func destination(for vertex: Vertex<Element>) -> Destination<Element> {
        return destinations.filter { $0.vertex == vertex }.first ?? Destination(vertex)
    }
    
    private func relax(_ vertex: Vertex<Element>) {
        vertex.adjacentEdges.forEach { (edge) in
            
            let edgeDestination = edge.destination
            let nextDestination = destination(for: edgeDestination)
            let currentDestination = destination(for: vertex)
            
            if nextDestination.totalWeight > (currentDestination.totalWeight + edge.weight) {
                nextDestination.totalWeight = currentDestination.totalWeight + edge.weight
                nextDestination.previousVertex = edge.source
                
                priorityQueue.insert(nextDestination.vertex, priority: nextDestination.totalWeight)
            }
        }
    }
    
    public func distanceTo(_ vertex: Vertex<Element>) -> Double {
        return destination(for: vertex).totalWeight
    }
    
    public func hasPathTo(_ vertex: Vertex<Element>) -> Bool {
        return destination(for: vertex).isReachable
    }
    
    public func pathTo(_ vertex: Vertex<Element>) -> [Vertex<Element>]? {
        guard hasPathTo(vertex) else {
            return nil
        }
        
        var results: [Vertex<Element>] = [vertex]
        
        var currentDestination = destination(for: vertex)
        while let previousVertex = currentDestination.previousVertex {
            results.insert(previousVertex, at: 0)
            currentDestination = destination(for: previousVertex)
        }
        
        return results
    }
}
