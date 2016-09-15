//
//  LineMoverNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit

class LineMoverNode:MoverNode {
    fileprivate var line:SKShapeNode!
    
    override init() {
        super.init()
        
        line = SKShapeNode()
        line.lineWidth = 10
        line.lineCap = .round
        line.lineJoin = .miter
        line.fillColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        line.strokeColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        self.addChild(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LineMoverNode {
    override func updatePath() {
        let ref = CGMutablePath()
        ref.move(to: origin)
        ref.addLine(to: endPoint)
        line.path = ref
    }
}
