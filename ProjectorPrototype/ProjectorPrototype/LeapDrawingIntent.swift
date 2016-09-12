//
//  LeapDrawingIntent.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/9/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import Cocoa
struct LeapDrawingIntent {
    let strength: Float!
    let position: CGPoint!
    let color: NSColor!
    init(strength: Float, position: CGPoint, color: NSColor) {
        self.strength = strength
        self.position = position
        self.color = color
    }
}
