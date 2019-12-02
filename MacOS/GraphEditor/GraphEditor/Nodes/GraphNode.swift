//
//  GraphNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 31/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

class GraphNode: SKShapeNode {

    let graphNodeIndex: SKLabelNode!
    let index: String!

    init(index: String) {
        self.index = index
        graphNodeIndex = SKLabelNode(text: index)
        graphNodeIndex.fontColor = .black
        graphNodeIndex.name = "graphNodeIndex"
        graphNodeIndex.verticalAlignmentMode = .center

        super.init()

        let radius = 30
        self.path = CGPath(ellipseIn: CGRect(x: -radius, y: -radius, width: radius*2, height: radius*2), transform: nil)
        self.fillColor = .white
        self.strokeColor = .black
        self.lineWidth = 3
        self.addChild(graphNodeIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var description: String {
        return graphNodeIndex.text ?? "-1"
    }
}

