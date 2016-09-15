//
//  LineNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit

class LineNode:SKShapeNode {
    fileprivate var ref = CGMutablePath()
    
    convenience init(a:CGPoint, b:CGPoint) {
        self.init()
        
        ref = CGMutablePath()
        ref.move(to: a)
        ref.addLine(to: b)
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
    fileprivate func buildView() {
        lineWidth = 2
        strokeColor = SKColor.white
        fillColor = SKColor.white
    }
}
