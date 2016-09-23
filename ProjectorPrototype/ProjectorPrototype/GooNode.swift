//
//  GooNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/19/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import SpriteKit
import CoreImage


extension SKEffectNode {
    func blur() {
        shouldEnableEffects = true
        shouldRasterize = true
        
        let filter: CIFilter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius" : NSNumber(value:30.0)])!
        self.filter = filter
    }
    
    func sharpen() {
        shouldEnableEffects = true
        shouldRasterize = true
        
        let filter = CIFilter(name: "CIColorMatrix")!
        filter.setValue(CIVector(x: 1, y: 0, z: 0, w: 0), forKey: "inputRVector")
        filter.setValue(CIVector(x: 0, y: 1, z: 0, w: 0), forKey: "inputGVector")
        filter.setValue(CIVector(x: 0, y: 0, z: 1, w: 0), forKey: "inputBVector")
        filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 255), forKey: "inputAVector")
        filter.setValue(CIVector(x: 0, y: 0, z: 0, w: 0), forKey: "inputBiasVector")
        
        self.filter = filter
        
    }
}


// (GooNode)Sharp Node -> Blur Node -> Child Node

class GooNode: SKEffectNode {
    var blurNode:SKEffectNode
    
    override init() {
        blurNode = SKEffectNode()
        blurNode.blur()
        
        super.init()
        
        self.sharpen()
        self.addChild(blurNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeChildren(in nodes: [SKNode]) {
        blurNode.removeChildren(in: nodes)
    }
    
    override func addChild(_ node: SKNode) {
        if node != blurNode {
            blurNode.addChild(node)
        } else {
            super.addChild(node)
        }
    }
}
