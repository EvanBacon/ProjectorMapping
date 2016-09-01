//
//  NSColor+Bacon.swift
//  Circle
//
//  Created by Evan Bacon on 12/17/15.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import Foundation
import Cocoa
import CoreImage

//Accessor
extension NSColor {
    
    
    
    convenience public init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

    
    convenience init(red: Int, green: Int, blue: Int) {
        
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) {
        self.init(red:r, green: g, blue: b, alpha: a)
    }
    convenience init(r:CGFloat,g:CGFloat,b:CGFloat) {
        self.init(red:r, green: g, blue: b, alpha: 1)
    }
    
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
    
    
    /// Bacon.Accessor
    public var r: CGFloat {
        get {
            if let c = self.coreImageColor?.red {
                return c
            }
            return 0
        }
    }
    
    /// Bacon.Accessor
    public var g: CGFloat {
        get {
            if let c = self.coreImageColor?.green {
                return c
            }
            return 0
        }
    }
    
    /// Bacon.Accessor
    public var b: CGFloat {
        get {
            if let c = self.coreImageColor?.blue {
                return c
            }
            return 0
        }
    }
    /// Bacon.Accessor
    public var a: CGFloat {
        get {
            if let c = self.coreImageColor?.alpha {
                return c
            }
            return 0
        }
    }
    
    
    var red: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[0]
        }
    }
    
    var green: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[1]
        }
    }
    
    var blue: CGFloat {
        get {
            let components = CGColorGetComponents(self.CGColor)
            return components[2]
        }
    }
    
    var alpha: CGFloat {
        get {
            return CGColorGetAlpha(self.CGColor)
        }
    }
    
    
}


extension NSColor {
    
    
    
    convenience init(hex:String) {
        let hexString:NSString = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let scanner            = NSScanner(string: hexString as String)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        print(r, g, b)
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    
    
    func getColorAccentForColor(count: Int) -> [NSColor] {
        let interval = CGFloat(6.0)
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        
        
        var colors:[NSColor] = []
        for i in 0...count - 1  {
            
            var triad1 = h + (CGFloat(i)/interval)
            if triad1 >= 1.0 {
                triad1 = triad1 - 1
            }
            let triA = NSColor(
                hue: triad1,
                saturation: s,
                brightness: b,
                alpha: a)
            
            colors.append(triA)
        }
        
        return colors
    }
    
    
    func colorTriad() -> [NSColor] {
        
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        var triad1 = h + (1.0/3.0)
        if triad1 >= 1.0 {
            triad1 = triad1 - 1
        }
        let triA = NSColor(
            hue: triad1,
            saturation: s,
            brightness: b,
            alpha: a)
        
        var triad2 = h + (2.0/3.0)
        if triad2 >= 1.0 {
            triad2 = triad2 - 1
        }
        
        let triB = NSColor(
            hue: triad2,
            saturation: s,
            brightness: b,
            alpha: a)
        
        
        return [self,triA,triB]
    }
    
    
    func randomBrightColor() -> NSColor {
        let hue = CGFloat( Double(arc4random()) % 256.0 / 256.0 );  //  0.0 to 1.0
        let saturation = CGFloat( Double(arc4random()) % 128.0 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        let brightness = CGFloat( Double(arc4random()) % 128.0 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
    
    func randomSolidHueColor() -> NSColor {
        let randomHue:CGFloat = CGFloat(arc4random()) / CGFloat(UInt32.max)
        return NSColor(hue: randomHue, saturation: 1.0, brightness: 1.0, alpha: 1.0)
        
    }
    
    func randomDarkColor() -> NSColor {
        let hue = CGFloat( 1.0 );  //  Blue
        
        let saturation = CGFloat( Double(arc4random()) % 128.0 / 256.0 );  //  0.5 to 1.0, away from white
        let brightness = CGFloat( Double(arc4random()) % 128.0 / 256.0 );  //  0.5 to 1.0, away from black
        
        return NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        
    }
    
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return NSString(format:"#%06x", rgb) as String
    }
    
    func inverse () -> NSColor {
        var r:CGFloat = 0.0; var g:CGFloat = 0.0; var b:CGFloat = 0.0; var a:CGFloat = 0.0;
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return NSColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
    }
    
    func contrast () -> NSColor {
        if (self.closerToWhite()) { // Whites
            return NSColor.blackColor()
        }
        else{ // Blacks
            return NSColor.whiteColor()
        }
    }
    
    func closerToWhite() -> Bool {
        let components = CGColorGetComponents(self.CGColor)
        
        let r = Float(components[0] / 255.0) * 0.3
        let g = Float(components[1] / 255.0) * 0.59
        let b = Float(components[2] / 255.0) * 0.11
        
        return (Float(r + g + b) > Float(0.001961))
    }
    
    func lighter() -> NSColor {
        return lighterColor(0.2)
    }
    
    func darker() -> NSColor {
        return darkerColor(0.2)
    }
    
    func accent() -> NSColor {
        if (self.closerToWhite()) { // Whites
            return self.darker()
        }
        else{ // Blacks
            return self.lighter()
        }
    }
}


extension NSColor {
    /**
     Returns a lighter color by the provided percentage
     
     :param: lighting percent percentage
     :returns: lighter NSColor
     */
    func lighterColor(percent : Double) -> NSColor {
        return colorWithBrightnessFactor(CGFloat(1 + percent));
    }
    
    /**
     Returns a darker color by the provided percentage
     
     :param: darking percent percentage
     :returns: darker NSColor
     */
    func darkerColor(percent : Double) -> NSColor {
        return colorWithBrightnessFactor(CGFloat(1 - percent));
    }
    
    /**
     Return a modified color using the brightness factor provided
     
     :param: factor brightness factor
     :returns: modified color
     */
    func colorWithBrightnessFactor(factor: CGFloat) -> NSColor {
        var hue : CGFloat = 0
        var saturation : CGFloat = 0
        var brightness : CGFloat = 0
        var alpha : CGFloat = 0
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return NSColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
    }
}

