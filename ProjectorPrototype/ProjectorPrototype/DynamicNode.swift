//
//  DynamicNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/9/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation

import SpriteKit

class DynamicNode:SKSpriteNode {
    var id:Int!
    var animFrame:CGFloat = 0
    
    var radius:CGFloat!
    var v = CGPoint()
    var a = CGPoint()
    
    var offset:CGPoint = CGPoint() {
        didSet {
            position += offset
        }
    }
    
    convenience init(id:Int, origin:CGPoint, radius:CGFloat) {
        self.init(texture: SKTexture(imageNamed: "circle"), color: SKColor.blueColor(), size: CGSize(width: radius * 2, height: radius * 2))
        self.id = id
        self.animFrame = CGFloat(id)
        self.position = origin
        self.radius = radius
        v = CGPoint()
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(velocity:CGPoint, collide:CGPoint, cellWorld:CGSize) {
        a = CGPoint()
        
        a += velocity
        
        a += collide
        
        v += a
        
        if v.length() > 10 {
            v.normalize()
            v *= 10
        }
        
        var tempPoint:CGPoint = (position + v) - offset
        
        
        if (tempPoint.x + radius < 0) {tempPoint.x = cellWorld.width + tempPoint.x; }
        if (tempPoint.x - radius > cellWorld.width)  {tempPoint.x = tempPoint.x - cellWorld.width;}
        if (tempPoint.y + radius < 0) { tempPoint.y = cellWorld.height + tempPoint.y; }
        if (tempPoint.y - radius > cellWorld.height)  { tempPoint.y = tempPoint.y - cellWorld.height;}
        
        position = (tempPoint + offset)
        
        radius = cos(CGFloat(GLKMathDegreesToRadians(Float(animFrame)))) * 5 + 8
        size = CGSize(width: radius * 2, height: radius * 2)
        
        animFrame += 0.5
        
        v *= 0.98
    }
}
