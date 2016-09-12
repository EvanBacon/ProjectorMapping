//
//  LeapVector+Extension.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/9/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation


extension LeapVector {
    func toPoint() -> CGPoint {
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
}

func + (lhs: LeapVector, rhs: LeapVector) -> LeapVector {
    return LeapVector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

func - (lhs: LeapVector, rhs: LeapVector) -> LeapVector {
    return LeapVector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

