//
//  NSImage+Extensions.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/9/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import Cocoa

extension NSImage {
    func getPixelColor(pos: CGPoint) -> NSColor {
        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        //        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        var a = CGFloat(1.0)
        
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func placeImageOnImage(pos: NSPoint, top: NSImage) -> NSImage {
        
        let fullyRect = NSRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let rect = NSRect(x: pos.x - 25, y: (self.size.height - pos.y) - 25, width: 50, height: 50)
        
        NSLog("\(rect, fullyRect)", "")
        lockFocus()
        
        //        self.drawInRect(fullyRect)
        
        //        let red = NSColor.redColor()
        //        red.setFill()
        top.drawInRect(rect)
        
        unlockFocus()
        return self
    }
    
    func DrawImageInNSGraphicsContext(size: CGSize, drawFunc: ()->()) -> NSImage {
        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0)
        
        let context = NSGraphicsContext(bitmapImageRep: rep!)
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(context)
        
        drawFunc()
        
        NSGraphicsContext.restoreGraphicsState()
        
        let image = NSImage(size: size)
        image.addRepresentation(rep!)
        
        return image
    }
    
}

extension NSImage {
    var CGImage: CGImageRef {
        get {
            return self.CGImageForProposedRect(nil, context: nil, hints: nil)!
        }
    }
}
