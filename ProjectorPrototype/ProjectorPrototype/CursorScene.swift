//
//  CursorScene.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/31/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import SpriteKit


extension CursorScene: LeapMotionManagerDelegate {
    func leapMotionManagerDidUpdateFrame(frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                leftHand.fillColor = NSColor.clearColor()
                return
            }
            for hand in hands {
                leftHand.position = adjustedPoint(hand.palmPosition)
                if hand.pastCenter {
                    leftHand.fillColor = NSColor.greenColor()
                } else {
                    leftHand.fillColor = NSColor.redColor()
                }
                break
            }
        }
    }
    func rotateGesture(gesture: LeapCircleGesture) {
     
    }
    func swipeGesture(gesture: LeapSwipeGesture) {
        var direction = gesture.direction
        var speed = gesture.speed
        var position = gesture.position
        var id = gesture.id
        
        
        switch gesture.state {
        case LEAP_GESTURE_STATE_START:
            break
        case LEAP_GESTURE_STATE_UPDATE:
            break
        case LEAP_GESTURE_STATE_STOP:
            break
        case LEAP_GESTURE_STATE_INVALID:
            break
        default:
            fatalError("WTF")
            break
        }

        print(direction, direction.direction2D, speed, position, id, gesture.state)
    }
    func keyTapGesture(gesture: LeapKeyTapGesture) {
        
    }
    func screenTapGesture(gesture: LeapScreenTapGesture) {
        
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

class CursorScene: SKScene {
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
