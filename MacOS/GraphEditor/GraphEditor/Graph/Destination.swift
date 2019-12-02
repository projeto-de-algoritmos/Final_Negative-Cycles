//
//  Destination.swift
//  ATEdgeWeightedDigraph
//
//  Created by Dejan on 01/08/2018.
//  Copyright © 2018 agostini.tech. All rights reserved.
//

import Foundation

class Destination<Element: Equatable> {
    let vertex: Vertex<Element>
    var previousVertex: Vertex<Element>?
    var totalWeight: Double = Double.greatestFiniteMagnitude
    var isReachable: Bool {
        return totalWeight < Double.greatestFiniteMagnitude
    }
    
    init(_ vertex: Vertex<Element>) {
        self.vertex = vertex
    }
}
