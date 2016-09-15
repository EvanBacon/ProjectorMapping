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
    func getPixelColor(_ pos: CGPoint) -> NSColor {
        
        let pixelData = self.CGImage.dataProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        //        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        let a = CGFloat(1.0)
        
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func placeImageOnImage(_ pos: NSPoint, top: NSImage) -> NSImage {
        
        let fullyRect = NSRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let rect = NSRect(x: pos.x - 25, y: (self.size.height - pos.y) - 25, width: 50, height: 50)
        
        NSLog("\(rect, fullyRect)", "")
        lockFocus()
        
        //        self.drawInRect(fullyRect)
        
        //        let red = NSColor.redColor()
        //        red.setFill()
        top.draw(in: rect)
        
        unlockFocus()
        return self
    }
    
    func DrawImageInNSGraphicsContext(_ size: CGSize, drawFunc: ()->()) -> NSImage {
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
        NSGraphicsContext.setCurrent(context)
        
        drawFunc()
        
        NSGraphicsContext.restoreGraphicsState()
        
        let image = NSImage(size: size)
        image.addRepresentation(rep!)
        
        return image
    }
    
}

extension NSImage {
    var CGImage: CGImage {
        get {
            return self.cgImage(forProposedRect: nil, context: nil, hints: nil)!
        }
    }
}
