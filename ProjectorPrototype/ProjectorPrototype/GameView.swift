//
//  GameView.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import SceneKit
import SpriteKit

class GameView: SCNView {
    
    let imageView = NSImageView()
    var saveurl:NSURL!
    
    override func viewDidMoveToWindow() {
        imageView.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(imageView)
    }
    
    override func mouseDown(theEvent: NSEvent) {
        
        /* Called when a mouse click occurs */
        
        // check what nodes are clicked
        let p = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        let hitResults = self.hitTest(p, options: [SCNHitTestFirstFoundOnlyKey: true])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            
            let image: AnyObject? = result.node!.geometry?.firstMaterial?.diffuse.contents
            NSLog("\(image?.className)", "")
            
            if let url = image as? NSURL {
                saveurl = url
                let image = NSImage(contentsOfURL: url)
                
                let texcoords = result.textureCoordinatesWithMappingChannel((result.node!.geometry?.firstMaterial?.diffuse.mappingChannel)!)
                let hit = CGPointMake(CGFloat(texcoords.x * image!.size.width), CGFloat(texcoords.y * image!.size.height))
                
//                let color =  image!.getPixelColor(hit)
            
                let withEmoji = image!.placeImageOnImage(hit, top: NSImage(named: "obi")!)
                
                result.node!.geometry?.firstMaterial?.diffuse.contents = withEmoji
//                self.backgroundColor = color
                NSLog("\(hit)", "")

                imageView.image = withEmoji
            } else if let _ = image as? NSImage {

                let image = NSImage(contentsOfURL: saveurl)
                let texcoords = result.textureCoordinatesWithMappingChannel((result.node!.geometry?.firstMaterial?.diffuse.mappingChannel)!)
                let hit = CGPointMake(CGFloat(texcoords.x * image!.size.width), CGFloat(texcoords.y * image!.size.height))
                
                //                let color =  image!.getPixelColor(hit)
                
                let withEmoji = image!.placeImageOnImage(hit, top: NSImage(named: "obi")!)
                
                result.node!.geometry?.firstMaterial?.diffuse.contents = image

                //                self.backgroundColor = color
                NSLog("\(hit)", "")
                
                imageView.image = withEmoji            }
            else {
                if let color = image as? NSColor {
                self.layer?.backgroundColor = color.CGColor
                } else if let scene = image as? SKScene {
                    let texcoords = result.textureCoordinatesWithMappingChannel((result.node!.geometry?.firstMaterial?.diffuse.mappingChannel)!)
                    let hit = CGPointMake(CGFloat(texcoords.x * image!.size.width), CGFloat(texcoords.y * image!.size.height))

//                    let emoji = SKLabelNode(text: "Theo")
//                    emoji.fontColor = NSColor().randomSolidHueColor()
//                    emoji.fontSize = CGFloat(drand48() * 100) + 24

                    
                    if let scene = scene as? GameScene {
                        scene.fakeTouch(hit)
                    } else {
                    let tex = SKTexture(imageNamed: "obi")
                    let emoji = SKSpriteNode(texture: tex)
                    
                    
//                    emoji.zRotation = CGFloat(drand48() * M_PI)
                    emoji.position = hit
                    scene.addChild(emoji)
                    }
//                    self.layer?.backgroundColor = color.CGColor
                }
                
            }
        }
        
        super.mouseDown(theEvent)
    }
}

