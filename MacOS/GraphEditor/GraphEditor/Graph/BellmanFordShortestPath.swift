//
//  BellmanFordShortestPath.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 21/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

class BellmanFordShortestPath<Element: Equatable> {
    
    public var hasNegativeCycle: Bool {
        return negativeCycle != nil
    }
    
    private(set) var negativeCycle: [Vertex<Element>]?
    
    private var destinations: [Destination<Element>] = []
    private var relaxationQueue: ATQueue<Vertex<Element>> = ATQueue() // :)
    private var iteration: Int = 0
    private let graph: EdgeWeightedDigraph<Element>
    
    init(_ graph: EdgeWeightedDigraph<Element>, source: Vertex<Element>) {
        
        self.graph = graph
        
        graph.vertices.forEach { self.destinations.append(Destination($0)) }
        
        let sourceDestination = destination(for: source)
        sourceDestination.totalWeight = 0.0
        
        relaxationQueue.enqueue(source)
        
        while (relaxationQueue.isEmpty == false && self.hasNegativeCycle == false) {
            if let vertex = relaxationQueue.dequeue() {
                self.relax(vertex)
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
                
                if (relaxationQueue.contains(edgeDestination) == false) {
                    relaxationQueue.enqueue(edgeDestination)
                }
            }
            
            iteration += 1
            
            if (iteration % self.graph.edgesCount() == 0) {
                findNegativeCycle()
            }
        }
    }
    
    public func distanceTo(_ vertex: Vertex<Element>) -> Double {
        return destination(for: vertex).totalWeight
    }
    
    public func hasPathTo(_ vertex: Vertex<Element>) -> Bool {
        return destination(for: vertex).totalWeight < Double.greatestFiniteMagnitude
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
    
    private func findNegativeCycle() {
        let shortestPath = EdgeWeightedDigraph<Element>()
        
        self.destinations.forEach { (destination) in
            if destination.isReachable {
                if let previous = destination.previousVertex, let edge = previous.edgeForDestination(destination.vertex) {
                    shortestPath.addEdge(source: self.vertex(edge.source, fromArray: shortestPath.vertices),
                                         destination: self.vertex(edge.destination, fromArray: shortestPath.vertices),
                                         weight: edge.weight)
                }
            }
        }
        
        let cycleFinder = EdgeWeightedDirectedCycle(shortestPath)
        self.negativeCycle = cycleFinder.hasCycle ? cycleFinder.cycle : nil
    }

    func shortestPath() -> EdgeWeightedDigraph<Element> {
        let shortestPath = EdgeWeightedDigraph<Element>()

        self.destinations.forEach { (destination) in
            if destination.isReachable {
                if let previous = destination.previousVertex, let edge = previous.edgeForDestination(destination.vertex) {
                    shortestPath.addEdge(source: self.vertex(edge.source, fromArray: shortestPath.vertices),
                                         destination: self.vertex(edge.destination, fromArray: shortestPath.vertices),
                                         weight: edge.weight)
                }
            }
        }

        return shortestPath
    }
    
    // Returns an existing vertex from the graph or creates a new one if the graph doesn't contain the vertex.
    private func vertex(_ vertex: Vertex<Element>, fromArray array: [Vertex<Element>]) -> Vertex<Element> {
        if let idx = array.index(of: vertex) {
            return array[idx]
        } else {
            return Vertex(vertex.value)
        }
    }
}
