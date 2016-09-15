//
//  MoverNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit

class MoverNode:SKNode {
    var index:NodeIndex!
    var padding:CGFloat!
    
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
    
    convenience init(index:NodeIndex, origin:CGPoint, padding:CGFloat) {
        self.init()
        self.index = index
        self.origin = origin
        self.endPoint = origin
        self.padding = padding
        updatePath()
    }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension MoverNode {
    
    func get(_ data:[[MoverNode?]], i:NodeIndex) -> MoverNode? {
        guard i.x >= 0 && i.x < data.count else { return nil }
        guard i.y >= 0 && i.y < data[i.x].count else { return nil }
        return data[i.x][i.y]
    }
    
    func neighbors(_ data:[[MoverNode?]], i:NodeIndex) -> [MoverNode] {
        var neighbors:[MoverNode] = []
        
        for n in i.neighbors() {
            if let node = get(data, i: n) {
                neighbors.append(node)
            }
        }
        return neighbors
    }

    
    func updatePath() {
    }

    func input(_ data:[[MoverNode?]], magnitude:CGFloat, point:CGPoint) -> [NodeIndex] {
        var childrenIndexes:[NodeIndex] = [index]
        
        var copy = data
        
        copy[index.x][index.y] = nil
        
        let lerpAmount:CGFloat = 0.8
        
        lerpToTarget(magnitude, point: point)
        
        let lerpVal = magnitude * lerpAmount
        
        if lerpVal < 0.1 {
            return childrenIndexes
        }
        let neighboringNodes = neighbors(copy, i: index)
        
        for node in neighboringNodes {
            for childIndex in node.input(copy, magnitude: lerpVal, point: point) {
                copy[childIndex.x][childIndex.y] = nil
                childrenIndexes.append(childIndex)
            }
        }
        
        return childrenIndexes
    }
    
    func lerpToTarget(_ magnitude:CGFloat, point:CGPoint) {
        let target = origin.cartesian((point - origin).angle, radius: min(point.distanceTo(endPoint) * magnitude, padding * 10))
        
        endPoint = lerp(start: endPoint, end: target, t: 0.1)
    }
}
