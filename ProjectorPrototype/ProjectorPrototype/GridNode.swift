//
//  GridNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/8/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import SpriteKit


class GridNode:SKSpriteNode {
    private var padding:CGFloat = 0
    private var gridSize:Int = 0

    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init(size:Int, padding:CGFloat) {
        self.init(texture:nil, color: SKColor.clearColor(), size: CGSize(width: CGFloat(size - 1) * padding, height: CGFloat(size - 1) * padding))
        
        self.padding = padding

        buildView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GridNode {
    private func buildView() {
        self.anchorPoint = CGPoint()
        for i in 0..<gridSize {
            /// Build vertical lines
            var a = CGPoint(x: CGFloat(i) * (padding), y: 0)
            var b = CGPoint(x: CGFloat(i) * (padding), y: self.size.height)
            var node = LineNode(
                a: a,
                b: b
            )
            self.addChild(node)
            
            /// Build horizontal lines
            a = CGPoint(x: 0, y: CGFloat(i) * (padding))
            b = CGPoint(x: self.size.width, y: CGFloat(i) * (padding))
            node = LineNode(
                a: a,
                b: b
            )
            self.addChild(node)
        }
    }
}
