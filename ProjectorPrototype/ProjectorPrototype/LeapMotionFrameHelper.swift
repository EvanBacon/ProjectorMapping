//
//  LeapMotionFrameHelper.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import Foundation

let PINCH_THRESHOLD:Float = 0.98
let GRABBING_THRESHOLD:Float = 0.98

//extension LeapFrame {
//    var pinching:Bool {
//        
////        if let hands = frame.hands as? [LeapHand] {
//
//        get {
//         return false
//        }
//    }
//}
extension LeapHand {
    var pinching:Bool {
        get {
            return pinchStrength >= PINCH_THRESHOLD || grabbing
        }
    }
    
    var grabbing:Bool {
        get {
            return grabStrength >= GRABBING_THRESHOLD
        }
    }
    
    
    var index:LeapFinger? {
        get {
            for finger in fingers {
                if let finger = finger as? LeapFinger {
                    if finger.type == LEAP_FINGER_TYPE_INDEX {
                        return finger
                    }
                }
            }
            return nil
        }
    }
    var middle:LeapFinger? {
        get {
            for finger in fingers {
                if let finger = finger as? LeapFinger {
                    if finger.type == LEAP_FINGER_TYPE_MIDDLE {
                        return finger
                    }
                }
            }
            return nil
        }
    }
    var ring:LeapFinger? {
        get {
            for finger in fingers {
                if let finger = finger as? LeapFinger {
                    if finger.type == LEAP_FINGER_TYPE_RING {
                        return finger
                    }
                }
            }
            return nil
        }
    }

    var pinky:LeapFinger? {
        get {
            for finger in fingers {
                if let finger = finger as? LeapFinger {
                    if finger.type == LEAP_FINGER_TYPE_PINKY {
                        return finger
                    }
                }
            }
            return nil
        }
    }

    var thumb:LeapFinger? {
        get {
            for finger in fingers {
                if let finger = finger as? LeapFinger {
                    if finger.type == LEAP_FINGER_TYPE_THUMB {
                        return finger
                    }
                }
            }
            return nil
        }
    }

    
}

