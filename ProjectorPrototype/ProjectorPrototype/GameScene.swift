//
//  GameScene.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import SpriteKit

extension LeapVector {
    func toPoint() -> CGPoint {
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
}
extension GameScene: LeapMotionManagerDelegate {
    func leapMotionManagerDidUpdateFrame(frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                leftHand.fillColor = NSColor.clearColor()
                return
            }
            for hand in hands {
                
                if hand.isLeft {
//                    leftHand.fillColor = hand.pinching ? NSColor.blueColor() : NSColor.redColor()
                    leftHand.position = adjustedPoint(hand.palmPosition)

                    if hand.pinching {
                        
                        leftHand.fillColor = NSColor.blueColor()
                        addDrawing(hand)
                    } else {
                        if isDrawing {
                            //End Line 
                            endDrawing()
                        }
                        leftHand.fillColor = NSColor.redColor()
                    }
                    isDrawing = hand.pinching
                }
            }
        }
    }
    
    func endDrawing() {
        drawing.append([])
    }
    func addDrawing(hand:LeapHand) {
        let strength = hand.palmVelocity.magnitude
        let position = adjustedPoint(hand.palmPosition)

//        let position = (hand.index?.tipPosition.toPoint())!
        let intent = LeapDrawingIntent(strength: strength, position: position, color: NSColor.greenColor())
        
        renderDrawing(intent)
    }
    
    func renderDrawing(intent:LeapDrawingIntent) {
        drawing[drawing.count - 1].append(intent)

        dispatch_async(dispatch_get_main_queue(),{

            self.enumerateChildNodesWithName("line", usingBlock: { node, stop in
                node.removeFromParent()
                
            })
        
            for line in self.drawing {

        if let path = self.buildPath(line) {
            let shapeNode = SKShapeNode()
            shapeNode.path = path
            shapeNode.name = "line"
            shapeNode.strokeColor = intent.color
            shapeNode.lineWidth = 4
            shapeNode.zPosition = 1
            
                self.addChild(shapeNode)
        }
            }
        })
        

    }
    
    
    func buildPath(line: [LeapDrawingIntent]) -> CGPathRef? {
            //1
            if line.count <= 1 {
                return nil
            }
        
            
            //2
            let ref = CGPathCreateMutable()
            
            //3
            for i in 0..<line.count {
                let p = line[i].position
                
                //4
                if i == 0 {
                    CGPathMoveToPoint(ref, nil, p.x, p.y)
                } else {
                    CGPathAddLineToPoint(ref, nil, p.x, p.y)
                }
            }
            
            return ref
        
    }
    
    func adjustedPoint(point:LeapVector) -> CGPoint {
        
        let appWidth = self.frame.width
        let appHeight = self.frame.height
        
        if let currentFrame = LeapMotionManager.sharedInstance.currentFrame {
        let iBox = currentFrame.interactionBox()
        
        
            let normalizedPoint = iBox.normalizePoint(point, clamp: true).toPoint()
        
            let appX = normalizedPoint.x * appWidth
            let appY = (normalizedPoint.y) * appHeight
//            //The z-coordinate is not used
//
        return CGPoint(x: appX, y: appY)
        } else {
            return CGPointZero
        }
    }
}

class GameScene: SKScene {
    
    public var labelNode: SKLabelNode?
    public var cursorNode: SKShapeNode?
    
    override init(size: CGSize) {
        super.init(size: size)
        scaleMode = .ResizeFill
        labelNode = SKLabelNode(text: "tracking")
        labelNode?.position = CGPoint(x: 100, y: 400)
        self.addChild(labelNode!)
        cursorNode = SKShapeNode(circleOfRadius: 25.0)
        cursorNode?.strokeColor = SKColor.greenColor()
        self.addChild(cursorNode!)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isDrawing:Bool = false
    var paths:[SKShapeNode] = []
    var drawing:[[LeapDrawingIntent]] = [[]]
    
    var leftHand:SKShapeNode!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.redColor()
        LeapMotionManager.sharedInstance.addListener(self)


        leftHand = SKShapeNode(circleOfRadius:80)
        leftHand.fillColor = NSColor.redColor()
        leftHand.strokeColor = NSColor.clearColor()
    
        leftHand.xScale = 0.1
        leftHand.yScale = 0.1
        leftHand.physicsBody?.collisionBitMask = 0
        leftHand.physicsBody?.categoryBitMask = 1
        leftHand.physicsBody?.contactTestBitMask = 1
        
        addChild(leftHand)
    }
}


struct LeapDrawingIntent {
    let strength:Float!
    let position:CGPoint!
    let color:NSColor!
    init(strength:Float, position:CGPoint, color:NSColor) {
        self.strength = strength
        self.position = position
        self.color = color
    }
}

