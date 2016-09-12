//
//  SpriteMoverNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit
class SpriteMoverNode:MoverNode {
    private  var node:SKSpriteNode!
    private let nodeSize:CGFloat = 20
    
    override init() {
        super.init()
        node = SKSpriteNode(imageNamed: "snowflake")
//        node.colorBlendFactor = 1
//        node.color = NSColor().randomBrightColor()
        node.size = CGSize(width: nodeSize, height: nodeSize)
        self.addChild(node)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SpriteMoverNode {
    override func updatePath() {
        node.position = endPoint
    }
}
