//
//  Scene.swift
//  GraphEditor
//
//  Created by Matheus Felizola Freires on 16/09/19.
//  Copyright © 2019 Matheus Felizola Freires. All rights reserved.
//

import SpriteKit

extension SKView {
    override open func scrollWheel(with event: NSEvent) {
        super.scrollWheel(with: event)
        scene?.scrollWheel(with: event)
    }
    
    open override func rotate(with event: NSEvent) {
        super.rotate(with: event)
        scene?.rotate(with: event)
    }
}
