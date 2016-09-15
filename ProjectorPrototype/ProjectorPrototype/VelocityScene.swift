//
//  GameScene.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import SpriteKit

class VelocityScene: SKScene {
    
    var touchPoint:CGPoint?
    
    
    var velocityField:VelocityFieldNode!
    var velocity:CGPoint?
    
    override init(size:CGSize) {
        super.init(size:size)
        buildField()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SKNode {
    func centerInParent() {
        guard let parent = self.parent else { return }
        position = CGPoint(x:parent.frame.midX, y:parent.frame.midY)
    }
}

extension VelocityScene {
    func buildField() {
        velocityField = buildNode()
        
}
    
    
    func buildNode() -> VelocityFieldNode {
        let grid = VelocityFieldNode(nodes: 250, size: size, gridSize: size.width * 0.1, radius: size.width * 0.33)
        grid.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.addChild(grid)
        grid.centerInParent()

        return grid
    }
}

extension VelocityScene {
    
    func fakeTouch(_ position:CGPoint) {
        if let touchPoint = touchPoint {
            velocity = position - touchPoint
        }
        
        touchPoint = position
    }
    
    func updateField() {
        if let touchPoint = touchPoint {
            if let velocity = velocity {
                
                let halfNode = CGPoint(x: velocityField.size.width / 2, y: velocityField.size.height / 2)
                let convertedPoint = (self.convert(touchPoint, to: velocityField)) + halfNode
                velocityField.addV(velocity, touchPoint:convertedPoint)
            }
        }
        
        velocityField.update()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateField()
    }
    

}

extension CGFloat {
    mutating func roundToValue(_ value:CGFloat) -> Int {
        let v = self
        return Int(Float(value) * roundf(Float(Double(v / value))))
    }
}


