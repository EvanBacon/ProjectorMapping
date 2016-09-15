//
//  LeapCircleGestureRecognizer.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/1/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation

//import UIKit

enum RotatationDirection: String
{
    case AntiClockwise = "Anti-Clockwise"
    case Clockwise = "Clockwise"
}

open class LeapCircleGestureRecognizer: NSGestureRecognizer
{
    fileprivate var touchPoints: [CGPoint] = [CGPoint]()
    fileprivate var gestureAngle: Float = 0
    
    fileprivate var rotatationDirection: RotatationDirection!
    fileprivate var currentAngle: Float?
    fileprivate var averagePoint: CGPoint?
    fileprivate var distanceFromAverage: Float?
    
    var numberOfHands:Int = 1
    var numberOfFingers:Int = 1
    
    
    // MARK: Initialise
    
    public override init(target:Any, action:Selector?)
    {
        super.init(target: target, action: action)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
