//
//  GameScene.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import Foundation
import Cocoa
import SpriteKit

class VectorScene: SKScene {
    
    let autoReset = false
    let useVectors = false
    let useCursor = false

    let gridSize:Int = 50
    let padding:CGFloat = 20

    var grid:GridNode!
    var nodes:[[MoverNode?]]!
    
    var touchPoint:CGPoint?
    
    override init(size: CGSize) {
        super.init(size: size)
        buildField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
//    override func didMoveToView(view: SKView) {
//        buildField()
//    }
}

extension VectorScene {
    func buildField() {
        nodes = Array(repeating: Array(repeating: nil, count: gridSize), count: gridSize)
        
        grid = buildGrid()
        self.addChild(grid)
        
        for i in 0..<gridSize {
            for j in 0..<gridSize {
                let node = buildNode(CGPoint(x: CGFloat(i) * padding, y: CGFloat(j) * padding), x: i, y: j)
                nodes[Int(i)][Int(j)] = node
                grid.addChild(node)
            }
        }
    }
    
    func buildGrid() -> GridNode {
        let grid = GridNode(size: gridSize, padding: padding)
        grid.position = CGPoint(x:self.frame.midX - grid.size.width / 2, y:self.frame.midY - grid.size.height / 2 )
        
        return grid
    }
    
    func buildNode(_ origin:CGPoint, x:Int, y:Int) -> MoverNode {
        if useVectors {
            return LineMoverNode(index: NodeIndex(x: x, y: y), origin: origin, padding: padding)
        } else {            
            return SpriteMoverNode(index: NodeIndex(x: x, y: y), origin: origin, padding: padding)
        }
    }
    
}

extension VectorScene {
    
    override func mouseDown(with theEvent: NSEvent) {
        touchPoint = theEvent.location(in: self)

    }
    override func mouseDragged(with theEvent: NSEvent) {
        touchPoint = theEvent.location(in: self)

    }
    
    override func mouseUp(with theEvent: NSEvent) {
        touchPoint = nil
    }
    override func mouseExited(with theEvent: NSEvent) {
        touchPoint = nil
    }
    
}

extension VectorScene {
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        if let location = touchPoint {
            fakeTouch(self.convert(location, to: grid))
        } else {
            reset()
        }
    }
    
    func reset() {
        guard autoReset else { return }
        for family in nodes {
            for child in family {
                if let node = child {
                    node.lerpToTarget(1.0, point:node.origin)
                }
            }
        }
    }
    
    
    func fakeTouch(_ point:CGPoint, velocity:CGFloat=1.0) {
        
        self.updateCursor(point)
        
        var p = point
        let x = p.x.roundToValue(padding) / Int(padding)
        let y = p.y.roundToValue(padding) / Int(padding)
        
        guard x >= 0 && x < nodes.count else { return }
        guard y >= 0 && y < nodes[x].count else { return }
        
        if let node = nodes[x][y] {
            _ = node.input(nodes, magnitude: velocity, point:point)
        }
    }
}
extension VectorScene {
    
    
    func updateCursor(_ point:CGPoint) {
        guard useCursor else { return }
        if let cursor = grid.childNode(withName: "cursor") {
            cursor.removeFromParent()
        }
        
        let p = SKShapeNode(circleOfRadius: 10)
        p.fillColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        p.position = point
        p.name = "cursor"
        grid.addChild(p)
    }
}


