//
//  ArrowNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/12/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import SpriteKit

class ArrowNode:SKNode {
    var origin:CGPoint! {
        didSet {
            self.endPoint = origin
        }
    }
    
    var endPoint:CGPoint! {
        didSet {
            updatePath()
        }
    }
    
    private var line:SKShapeNode!
    
    override init() {
        super.init()
        
        line = SKShapeNode()
        line.lineWidth = 4
        line.lineCap = .Round
        line.lineJoin = .Miter
        
        line.strokeColor = SKColor( red: 0.5, green: 0.7297, blue: 1.0, alpha: 1.0 )
        self.addChild(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ArrowNode {
    func updatePath() {
        let ref = CGPathCreateMutable()
        CGPathMoveToPoint(ref, nil, origin.x, origin.y)
        
        CGPathAddLineToPoint(ref, nil, endPoint.x , endPoint.y)
        line.path = ref
    }
}