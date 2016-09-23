//
//  VelocityFieldNode.swift
//  Vector Field
//
//  Created by Evan Bacon on 9/12/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import SpriteKit

class VelocityFieldNode:SKSpriteNode {
    

    var balls = [DynamicNode]()
    var gridSize:CGFloat = 0
    var cells = [[VelocityCell?]]()
    var cellSize = CGSize()
    var friction:CGFloat = 0.99;
    
    var gooNode:GooNode!
    
    var cropNode:SKCropNode!

    
    convenience init(nodes:Int, size:CGSize, gridSize:CGFloat, radius:CGFloat) {
        self.init(texture: nil, color: SKColor.black, size: size)
        self.gridSize = gridSize;
        self.setup(nodes, nodeRadius: radius)
        
    }
    
    override init(texture: SKTexture?, color: SKColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension VelocityFieldNode {
    
    func setup(_ nodeCount:Int, nodeRadius:CGFloat) {
        
        gooNode = GooNode()
        let node = SKCropNode()
        node.maskNode = SKSpriteNode(texture: nil, color:SKColor.black, size: self.size)
        self.addChild(node)
        node.addChild(gooNode)


        
        let offset = CGPoint(x: -(frame.size.width / 2), y: -(frame.size.height / 2))
        for i in 0..<nodeCount {
            let node = DynamicNode(id: i, origin: CGPoint(x: size.width, y: size.height).random(), radius: nodeRadius)
            balls.append(node)
            
            node.offset = offset
            gooNode.addChild(node)

        }
        
        
        if (size.width.truncatingRemainder(dividingBy: gridSize) == 0) {
            cellSize.width = floor(size.width / gridSize);
        } else {
            cellSize.width = floor(size.width / gridSize) + 1;
        }
        
        if (size.height.truncatingRemainder(dividingBy: gridSize) == 0) {
            cellSize.height = floor(size.height / gridSize);
        } else {
            cellSize.height = floor(size.height / gridSize) + 1;
        }
        
        
        cells = Array(repeating: Array(repeating: nil, count: Int(cellSize.height)), count: Int(cellSize.width))
        
        for ix in 0..<Int(cellSize.width) {
            for iy in 0..<Int(cellSize.height) {
                cells[ix][iy] = VelocityCell(frame: CGRect(x: CGFloat(ix) * gridSize, y: CGFloat(iy) * gridSize , width: gridSize, height: gridSize), interPoint: DynamicIndex(x: ix, y: iy), wSize: size, cellSize: cellSize, offset: offset);
                self.addChild(cells[ix][iy]!.arrowNode)
            }
        }
 
    }
    
    
    //..............................................
    // functions
    
    func update() {
        for width in cells {
            for cell in width {
                if let cell = cell {
                    cell.update(friction)
                    updateCell(cell)
                }
            }
        }
        
        for ball in balls {
            ball.update(getV(ball.position - ball.offset), collide: getCollideForBall(ball), cellWorld: size)
        }
    }
    
    
    func updateCell(_ cell:VelocityCell) {
        
        let iy = cell.innerPoint.y
        let ix = cell.innerPoint.x
        
        if let node = validPoint(cell.right, y: iy!) { node.addV(cell.diffV); }
        if let node = validPoint(ix!, y: cell.top) { node.addV(cell.diffV); }
        if let node = validPoint(cell.left, y: iy!) { node.addV(cell.diffV); }
        if let node = validPoint(ix!, y: cell.bottom) { node.addV(cell.diffV); }
        
    }
    
    func getCollideForBall(_ ball:DynamicNode) -> CGPoint {
        var c = CGPoint()
        var temp = CGPoint()
        
        for i in 0..<balls.count {
            if i != ball.id {
                let compareBall = balls[i]
                if (ball.position.distanceTo(compareBall.position) < ((ball.radius * 0.5) + (compareBall.radius * 0.5) )) {
                    temp = ball.position - compareBall.position
                    temp *= 0.08
                    c += temp
                }
            }
        }
        
        return c
        
    }
    
    func validPoint(_ x:Int, y:Int) -> VelocityCell? {
        guard x >= 0 && x < cells.count else { return nil }
        guard y >= 0 && y < cells[x].count else { return nil }
        if let cell = cells[x][y] {
            return cell
        } else {
            return nil
        }
    }
    
    func getV(_ point:CGPoint) -> CGPoint {
        
        let ix = Int(floor(point.x / gridSize))
        let iy = Int(floor(point.y / gridSize))
                
        let l2 = validPoint(ix+1, y: iy)?.velocity ?? CGPoint.zero
        let l3 = validPoint(ix, y: iy+1)?.velocity ?? CGPoint.zero
        let l4 = validPoint(ix+1, y: iy+1)?.velocity ?? CGPoint.zero
        
        let l1 = (validPoint(ix, y: iy)?.velocity ?? CGPoint.zero + l2 + l3 + l4) * 0.25
        
        
        /*
         int ix = max( floor( (_x-1)/gridSize ), 0 );
         int iy = max( floor( ( _y-1)/gridSize ), 0 );
         ix = min(ix, patches.length-1);
         iy = min(iy, patches[ix].length-1);
         return patches[ix][iy].chem;
         */
        return l1
    }
    
    
    
    func addV(_ _a:CGPoint, touchPoint:CGPoint) {
        
        var p = touchPoint
        let ix = p.x.roundToValue(gridSize) / Int(gridSize);
        let iy = p.y.roundToValue(gridSize) / Int(gridSize);
        
        /*
         patches[ix][iy].addChem(amt);
         */
        let arch = _a * 0.25
        
        if let cell = validPoint(ix, y: iy) {
            
            cell.addV(arch);
            
        }
        if let cell = validPoint(ix + 1, y: iy) {
            cell.addV(arch);
        }
        if let cell = validPoint(ix, y: iy + 1) {
            cell.addV(arch);
        }
        if let cell = validPoint(ix + 1, y: iy + 1) {
            cell.addV(arch);
        }
        
        //println("cellsX: " + ix + "  cellsY: " + iy);
    }
    
    func addChemPosition( _ amt:CGFloat, ix:Int, iy:Int) {
        /*
         if (ix<0) { ix = patches.length - ix; }
         if (ix>=patches.length) { ix  = 0; }
         if (iy<0) { iy = patches[ix].length - iy; }
         if (iy>=patches[ix].length ) { iy  = 0; }
         
         
         patches[ix][iy].addChem(amt);
         */
    }

    
    
    
}
