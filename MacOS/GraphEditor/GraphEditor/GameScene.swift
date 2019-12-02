//
//  GameScene.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 30/08/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var isDrawingLine = false
    var currentlyDrawnLine: EdgeNode<GraphNode>?
    var vertexes = [Vertex<String>]()
    var adjacencyList = EdgeWeightedDigraph<String>()
    fileprivate var initialNode: GraphNode?
    var negativeCycleLabel: SKLabelNode!
    var negativeCyclePathLabel: SKLabelNode!

    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        let cameraNode = SKCameraNode()
        
        cameraNode.position = .zero

        addChild(cameraNode)
        camera = cameraNode
        setupNegativeCycleLabel()
        setupNegativeCyclePathLabel()
    }

    func setNegativeCycleLabel(bool: Bool) {
        negativeCycleLabel.isHidden = false
        negativeCycleLabel.text = "There is a negative cycle? \(bool)"
    }

    func setNegativeCyclePathLabel(path: [Vertex<String>]?) {
        negativeCyclePathLabel.isHidden = false
        if let _path = path {
            negativeCyclePathLabel.text = "\(_path)"
        } else {
            negativeCyclePathLabel.text = "nil"
        }
    }

    func setupNegativeCyclePathLabel() {
        negativeCyclePathLabel = SKLabelNode(text: "")
        negativeCyclePathLabel.numberOfLines = 20
        negativeCyclePathLabel.position = CGPoint(x: -size.width * 0.5, y: -size.height/2 + size.height * 0.95)
        negativeCyclePathLabel.zPosition = 100
        negativeCyclePathLabel.fontColor = .black
        negativeCyclePathLabel.horizontalAlignmentMode = .left
        negativeCyclePathLabel.verticalAlignmentMode = .top
        negativeCyclePathLabel.fontSize = 24
        negativeCyclePathLabel.fontName = negativeCyclePathLabel.fontName! + "-Bold"
        self.camera!.addChild(negativeCyclePathLabel)
    }

    func setupNegativeCycleLabel() {
        negativeCycleLabel = SKLabelNode(text: "")
        negativeCycleLabel.numberOfLines = 20
        negativeCycleLabel.position = CGPoint(x: size.width * 0.01, y: -size.height/2 + size.height * 0.95)
        negativeCycleLabel.zPosition = 100
        negativeCycleLabel.fontColor = .black
        negativeCycleLabel.horizontalAlignmentMode = .left
        negativeCycleLabel.verticalAlignmentMode = .top
        negativeCycleLabel.fontSize = 24
        negativeCycleLabel.fontName = negativeCycleLabel.fontName! + "-Bold"
        self.camera!.addChild(negativeCycleLabel)
    }

    func touchUp(atPoint pos: CGPoint) {

        func dialogOKCancel(question: String, text: String) -> String? {
            let alert: NSAlert = NSAlert()
            alert.messageText = question
            alert.accessoryView = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
            alert.informativeText = text
            alert.alertStyle = NSAlert.Style.warning
            alert.addButton(withTitle: "Continue")
            let res = alert.runModal()
            if res == NSApplication.ModalResponse.alertFirstButtonReturn {
                return (alert.accessoryView as! NSTextField).stringValue
            }
            return nil
        }

        let name = dialogOKCancel(question: "What is the name of this vertex ?", text: "")
        let vertex = Vertex(name!)
        vertexes.append(vertex)

        let graphNode = GraphNode(index: name!)
        self.addChild(graphNode)
        graphNode.position = CGPoint(x: pos.x, y: pos.y)

        adjacencyList.addVertex(vertex)
    }
    
    override func mouseDown(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
                initialNode = touchedGraphNode
                break
            }
        }
        
        if let touchedGraphNode = touchedGraphNode {
            currentlyDrawnLine = EdgeNode(source: Vertex<GraphNode>(touchedGraphNode), initialPosition: touchedGraphNode.position)
            isDrawingLine = true
            self.addChild(currentlyDrawnLine!)
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        if isDrawingLine {
            currentlyDrawnLine!.moveEndOfLine(to: event.location(in: self))
        }
    }

    override func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)

        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
            }
        }
        if let _touchedGraphNode = touchedGraphNode,
            let vertex = vertexes.first(where: { $0.value == _touchedGraphNode.index }) {
            let bellmanFord = BellmanFordShortestPath(adjacencyList, source: vertex)
            setNegativeCycleLabel(bool: bellmanFord.hasNegativeCycle)
            setNegativeCyclePathLabel(path: bellmanFord.negativeCycle)
        }
    }

    func dialogOKCancel(question: String, text: String) -> Double? {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.accessoryView = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 20))
        alert.informativeText = text
        alert.alertStyle = NSAlert.Style.warning
        alert.addButton(withTitle: "Continue")
        let res = alert.runModal()
        if res == NSApplication.ModalResponse.alertFirstButtonReturn {
            return Double((alert.accessoryView as! NSTextField).stringValue)
        }
        return nil
    }
    
    override func scrollWheel(with event: NSEvent) {
        self.camera!.position = CGPoint(x: self.camera!.position.x - event.scrollingDeltaX/3, y: self.camera!.position.y + event.scrollingDeltaY/3)
    }
    
    override func rotate(with event: NSEvent) {
        self.camera?.zRotation = self.camera!.zRotation - event.deltaZ/60
    }
    
    override func mouseUp(with event: NSEvent) {
        let location = event.location(in: self)
        let touchedNodes = nodes(at: location)
        
        var touchedGraphNode: GraphNode? = nil
        for touchedNode in touchedNodes {
            if touchedNode is GraphNode {
                touchedGraphNode = (touchedNode as! GraphNode)
            } else if touchedNode.name == "deleteButton" {
                let source = (touchedNode.parent as! EdgeNode<GraphNode>).source
                if let destination = (touchedNode.parent as! EdgeNode<GraphNode>).destination {
                    let edgeNode = touchedNode.parent
                    edgeNode?.removeAllChildren()
                    edgeNode?.removeFromParent()
                }
            }
        }
        if isDrawingLine {
            if touchedGraphNode != nil {
                currentlyDrawnLine!.moveEndOfLine(to: touchedGraphNode!.position)
                currentlyDrawnLine!.destination = Vertex<GraphNode>(touchedGraphNode!)
            } else {
                currentlyDrawnLine!.removeFromParent()
            }

            if let _initialNode = initialNode,
                let _endNode = touchedGraphNode,
                _initialNode != touchedGraphNode {

                let answer = dialogOKCancel(question: "What's the weight of this edge?", text: "") ?? 0
                currentlyDrawnLine!.weight = answer

                guard let source = vertexes.first(where: { $0.value == _initialNode.index }) else { fatalError("There is no source node") }
                guard let destination = vertexes.first(where: { $0.value == _endNode.index }) else { fatalError("There is no destination node") }
                adjacencyList.addEdge(source: source, destination: destination, weight: answer)

            }
            
            currentlyDrawnLine = nil
            isDrawingLine = false

            initialNode = nil
        } else if touchedGraphNode == nil {
            self.touchUp(atPoint: event.location(in: self))
        }
    }
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            vertexes.removeAll()
            adjacencyList = EdgeWeightedDigraph<String>()
            self.children.forEach({ $0 == camera ? print("Camera Node") : $0.removeFromParent() })
            self.camera?.removeAllChildren()
            setupNegativeCyclePathLabel()
            setupNegativeCycleLabel()
            break
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }


    var startGraphNode: GraphNode?
    var endGraphNode: GraphNode?

}
