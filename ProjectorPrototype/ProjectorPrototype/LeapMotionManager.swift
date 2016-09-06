//
//  LeapMotionManager.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import Foundation

protocol LeapMotionManagerDelegate {
    func leapMotionManagerDidUpdateFrame(frame: LeapFrame)
    
    func rotateGesture(gesture:LeapCircleGesture) //Turning Door knob
    func swipeGesture(gesture:LeapSwipeGesture) //fast movement
    func keyTapGesture(gesture:LeapKeyTapGesture) // downward tap
    func screenTapGesture(gesture:LeapScreenTapGesture) //forward tap

//    func pinchGesture(gesture:LeapScreenTapGesture) // could be grab
//    func approveGesture(gesture:LeapScreenTapGesture) // Thumbs Up or thumbs down
//    func panGesture(gesture:LeapScreenTapGesture) //General Movement
    
}

class LeapMotionManager: NSObject, LeapDelegate {
    
    static let sharedInstance = LeapMotionManager()
    
    private var listeners:[LeapMotionManagerDelegate] = []
    
    func addListener(listener:LeapMotionManagerDelegate) {
        listeners.append(listener)
    }
    //TODO: Add remove listener
    var currentFrame:LeapFrame?

    let controller = LeapController()
    var rightHandPosition = LeapVector()
    var leftHandPosition = LeapVector()
    
    func run() {
        
        controller.addDelegate(self)
        print("running")
    }
    
    // MARK: - LeapDelegate Methods
    
    func onInit(controller: LeapController!) {
        print("initialized")
    }
    
    func onConnect(controller: LeapController!) {
        print("connected")
        controller.enableGesture(LEAP_GESTURE_TYPE_CIRCLE, enable: true)
        controller.enableGesture(LEAP_GESTURE_TYPE_KEY_TAP, enable: true)
        controller.enableGesture(LEAP_GESTURE_TYPE_SCREEN_TAP, enable: true)
        controller.enableGesture(LEAP_GESTURE_TYPE_SWIPE, enable: true)
        
        
    }
    
    func onDisconnect(controller: LeapController!) {
        print("disconnected")
    }
    
    func onServiceConnect(controller: LeapController!) {
        print("service disconnected")
    }
    
    func onDeviceChange(controller: LeapController!) {
        print("device changed")
    }
    
    func onExit(controller: LeapController!) {
        print("exited")
    }
    
    func onFrame(controller: LeapController!) {
        currentFrame = controller.frame(0) as LeapFrame
        
        if let gestures = currentFrame?.gestures(nil) as? [LeapGesture] {
            parseGestures(gestures)
        }
        
        
        for listener in listeners {
            listener.leapMotionManagerDidUpdateFrame(currentFrame!)
        }
        
        let hands = currentFrame!.hands as! [LeapHand]
        for hand in hands {
            if hand.isLeft {
                leftHandPosition = hand.palmPosition
//                print("left hand position: \(leftHandPosition)")
            } else if hand.isRight {
                rightHandPosition = hand.palmPosition
//                print("right hand position: \(rightHandPosition)")
            }
            
            for finger in hand.fingers {
                if let finger = finger as? LeapFinger {
//                    finger.direction
                }
            }
        }
    }
    
    func parseGestures(gestures:[LeapGesture]) {
        for gesture in gestures {
            parseGesture(gesture)
        }
    }
    
    func parseGesture(gesture:LeapGesture) {
        switch gesture.type {
        case LEAP_GESTURE_TYPE_CIRCLE:
            parseCircleGesture(gesture as! LeapCircleGesture)
            break;
        case LEAP_GESTURE_TYPE_SWIPE:
            parseSwipeGesture(gesture as! LeapSwipeGesture)
            break;
        case LEAP_GESTURE_TYPE_SCREEN_TAP:
            parseScreenTapGesture(gesture as! LeapScreenTapGesture)
            break;
        case LEAP_GESTURE_TYPE_KEY_TAP:
            parseKeyTapGesture(gesture as! LeapKeyTapGesture)
            break;
        default:
            break
        }
    }
    
    func parseCircleGesture(gesture:LeapCircleGesture) {
        for listener in listeners {
            listener.rotateGesture(gesture)
        }
//        var direction:String!
//        
//        if gesture.pointable.direction.angleTo(gesture.normal) <= LEAP_PI/4 {
//            direction = "clockwise"
//        } else {
//            direction = "counter-clockwise"
//        }
//        
//        var id = gesture.id
//        
//        var sweptAngle:Float = 0
//        if var previousUpdate = controller.frame(1).gesture(id) as? LeapCircleGesture {
//            sweptAngle = (gesture.progress - previousUpdate.progress) * 2 * LEAP_PI
//        }
//        
//        var type:String = ""
//        var progress = gesture.progress
//        var radius = gesture.radius
//        var angle = sweptAngle * LEAP_RAD_TO_DEG
//        
//        
//        switch gesture.state {
//        case LEAP_GESTURE_STATE_START:
//            break
//        case LEAP_GESTURE_STATE_UPDATE:
//            break
//        case LEAP_GESTURE_STATE_STOP:
//            break
//        case LEAP_GESTURE_STATE_INVALID:
//            break
//        default:
//            fatalError("WTF")
//            break
//        }
        
    }
    
    
    
    func parseSwipeGesture(gesture:LeapSwipeGesture) {
        for listener in listeners {
            listener.swipeGesture(gesture)
        }
        
//        var direction = gesture.direction
//        var speed = gesture.speed
//        var position = gesture.position
//        var id = gesture.id
//        
//        switch gesture.state {
//        case LEAP_GESTURE_STATE_START:
//            break
//        case LEAP_GESTURE_STATE_UPDATE:
//            break
//        case LEAP_GESTURE_STATE_STOP:
//            break
//        case LEAP_GESTURE_STATE_INVALID:
//            break
//        default:
//            fatalError("WTF")
//            break
//        }
    }

    func parseKeyTapGesture(gesture:LeapKeyTapGesture) {
        for listener in listeners {
            listener.keyTapGesture(gesture)
        }
//        var direction = gesture.direction
//        var position = gesture.position
//        var id = gesture.id
//        
//        switch gesture.state {
//        case LEAP_GESTURE_STATE_START:
//            break
//        case LEAP_GESTURE_STATE_UPDATE:
//            break
//        case LEAP_GESTURE_STATE_STOP:
//            break
//        case LEAP_GESTURE_STATE_INVALID:
//            break
//        default:
//            fatalError("WTF")
//            break
//        }
    }
    
    func parseScreenTapGesture(gesture:LeapScreenTapGesture) {
        for listener in listeners {
            listener.screenTapGesture(gesture)
        }
//        var direction = gesture.direction
//        var position = gesture.position
//        var id = gesture.id
//        
//        switch gesture.state {
//        case LEAP_GESTURE_STATE_START:
//            break
//        case LEAP_GESTURE_STATE_UPDATE:
//            break
//        case LEAP_GESTURE_STATE_STOP:
//            break
//        case LEAP_GESTURE_STATE_INVALID:
//            break
//        default:
//            fatalError("WTF")
//            break
//        }
    }
    
    func onFocusGained(controller: LeapController!) {
        print("focus gained")
    }
    
    func onFocusLost(controller: LeapController!) {
        print("focus lost")
    }
    
    }

extension LeapVector {
    var direction2D:LeapGestureDirection! {
        get {
        let x = self.x
        let y = self.y
        if x > 0 { //right
            if y > 0 { // up
                return abs(x) > abs(y) ? .Right : .Up
            } else { // down
                return abs(x) > abs(y) ? .Right : .Down
            }
        } else { //left
            if y > 0 { // up
                return abs(x) > abs(y) ? .Left : .Up
            } else { // down
                return abs(x) > abs(y) ? .Left : .Down
            }
        }
        }
    }

}
enum LeapGestureDirection: Int {
    case Invalid = -1
    case Left = 1
    case Right = 4
    case Up = 5
    case Down = 6
}

