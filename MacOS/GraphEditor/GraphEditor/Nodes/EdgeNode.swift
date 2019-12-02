//
//  EdgeNode.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 02/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

//class Custom: NSView {
//    override func draw(_ rect: CGRect) {
//        let path = trainglePathWithCenter(center: CGPoint(x: self.frame.origin.x + (self.frame.size.width / 2), y: self.frame.origin.y + (self.frame.size.height / 2)), side: self.bounds.width / 2)
//
//        path.stroke()
//    }
//
//    func trainglePathWithCenter(center: CGPoint, side: CGFloat) -> NSBezierPath {
//        let path = NSBezierPath()
//
//        let startX = center.x - side / 2
//        let startY = center.y - side / 2
//
//        path.move(to: CGPoint(x: startX, y: startY))
//        path.line(to: CGPoint(x: startX, y: startY + side))
//        path.line(to: CGPoint(x: startX + side, y: startY + side/2))
//        path.close()
//
//        return path
//    }
//}

class EdgeNode<T: Hashable>: SKShapeNode {
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    let source: Vertex<T>
    var destination: Vertex<T>? = nil
    var weight: Double = 0 {
        didSet {
            weightLabel.text = formatter.string(from: NSNumber(value: weight))
        }
    }
    
    let initialPosition: CGPoint

    var weightLabel: SKLabelNode!

    func setupWeightLabel() {
        weightLabel = SKLabelNode(text: formatter.string(from: NSNumber(value: weight)))
        weightLabel.name = "WeightLabel"
        weightLabel.fontColor = .black
        weightLabel.horizontalAlignmentMode = .center
        weightLabel.verticalAlignmentMode = .center
        weightLabel.fontSize = 22
        weightLabel.fontName = weightLabel.fontName! + "-Bold"
        addChild(weightLabel)
    }
    
    init(source: Vertex<T>, initialPosition: CGPoint) {
        self.source = source
        self.initialPosition = initialPosition
        super.init()
        setupWeightLabel()

        moveEndOfLine(to: initialPosition)
        self.strokeColor = .black
        self.lineWidth = 3
        self.zPosition = -1
    }
    
    func paintAsPath() {
        self.strokeColor = .orange
    }
    
    func unpaint() {
        self.strokeColor = .black
    }
    
    func moveEndOfLine(to pos: CGPoint) {
        let linePath = CGMutablePath()
        linePath.move(to: initialPosition)
        linePath.addLine(to: pos)
        self.path = linePath
        
        weightLabel.zRotation = atan2(initialPosition.y-pos.y, initialPosition.x-pos.x)
        if weightLabel.zRotation > CGFloat.pi/2 {
            weightLabel.zRotation -= CGFloat.pi
        } else if weightLabel.zRotation < -CGFloat.pi/2 {
            weightLabel.zRotation += CGFloat.pi
        }
        weightLabel.position = CGPoint(x: initialPosition.x + (pos.x-initialPosition.x)/2 + 10 * cos(weightLabel.zRotation + CGFloat.pi/2), y: initialPosition.y + (pos.y-initialPosition.y)/2 + 10 * sin(weightLabel.zRotation + CGFloat.pi/2))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
