//
//  LineNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit

class LineNode:SKShapeNode {
    private var ref = CGPathCreateMutable()
    
    convenience init(a:CGPoint, b:CGPoint) {
        self.init()
        
        ref = CGPathCreateMutable()
        CGPathMoveToPoint(ref, nil, a.x, a.y)
        
        CGPathAddLineToPoint(ref, nil, b.x, b.y)
        self.path = ref
    }
    
    override init() {
        super.init()
        
        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension LineNode {
    private func buildView() {
        lineWidth = 2
        strokeColor = SKColor.whiteColor()
        fillColor = SKColor.whiteColor()
    }
}