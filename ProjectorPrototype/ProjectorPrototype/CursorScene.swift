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
    func leapMotionManagerDidUpdateFrame(_ frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                leftHand.fillColor = NSColor.clear
                return
            }
            for hand in hands {
                leftHand.position = adjustedPoint(hand.palmPosition)
                if hand.pastCenter {
                    leftHand.fillColor = NSColor(red: 1, green: 1, blue: 0, alpha: 1)
                } else {
                    leftHand.fillColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
                }
                break
            }
        }
    }
    func rotateGesture(_ gesture: LeapCircleGesture) {
     
    }
    func swipeGesture(_ gesture: LeapSwipeGesture) {
        let direction = gesture.direction
        let speed = gesture.speed
        let position = gesture.position
        let id = gesture.id
        
        
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

        print(direction, direction?.direction2D, speed, position, id, gesture.state)
    }
    func keyTapGesture(_ gesture: LeapKeyTapGesture) {
        
    }
    func screenTapGesture(_ gesture: LeapScreenTapGesture) {
        
    }
    
    
    
    func adjustedPoint(_ point:LeapVector) -> CGPoint {
        
        let appWidth = self.frame.width
        let appHeight = self.frame.height
        
        if let currentFrame = LeapMotionManager.sharedInstance.currentFrame {
            let iBox = currentFrame.interactionBox()
            
            
            let normalizedPoint = iBox?.normalizePoint(point, clamp: true).toPoint()
            
            let appX = (normalizedPoint?.x)! * appWidth
            let appY = (normalizedPoint?.y)! * appHeight
            //            //The z-coordinate is not used
            //
            return CGPoint(x: appX, y: appY)
        } else {
            return CGPoint.zero
        }
    }
}

class CursorScene: SKScene {
    var leftHand:SKShapeNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        LeapMotionManager.sharedInstance.addListener(self)
        
        
        leftHand = SKShapeNode(circleOfRadius:80)
        leftHand.fillColor = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        leftHand.strokeColor = NSColor.clear
        
        leftHand.xScale = 0.1
        leftHand.yScale = 0.1
        leftHand.physicsBody?.collisionBitMask = 0
        leftHand.physicsBody?.categoryBitMask = 1
        leftHand.physicsBody?.contactTestBitMask = 1
        
        addChild(leftHand)
    }
}
