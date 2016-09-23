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
    var saveurl:URL!
    
    override func viewDidMoveToWindow() {
        imageView.frame = NSRect(x: 0, y: 0, width: 100, height: 100)
        self.addSubview(imageView)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        
        // check what nodes are clicked
        let p = self.convert(event.locationInWindow, from: nil)
        let hitResults = self.hitTest(p, options: [SCNHitTestOption.firstFoundOnly: true])
        // check that we clicked on at least one object
        

        
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: SCNHitTestResult = hitResults[0]
            
            
            let image = result.node.geometry?.firstMaterial?.diffuse.contents as AnyObject
            print("\(image.className)")
            
            
            if let url = image as? URL {

                saveurl = url
                let image = NSImage(contentsOf: url)
                
                let texcoords = result.textureCoordinates(withMappingChannel: (result.node.geometry?.firstMaterial?.diffuse.mappingChannel)!)
                let hit = CGPoint(x: CGFloat(texcoords.x * image!.size.width), y: CGFloat(texcoords.y * image!.size.height))
                
                //                let color =  image!.getPixelColor(hit)
                
                let withEmoji = image!.placeImageOnImage(hit, top: NSImage(named: "obi")!)
                
                result.node.geometry?.firstMaterial?.diffuse.contents = withEmoji
                //                self.backgroundColor = color
                print("\(hit)")
                
                imageView.image = withEmoji


            } else if let _ = image as? NSImage {
                
                let image = NSImage(contentsOf: saveurl)
                let texcoords = result.textureCoordinates(withMappingChannel: (result.node.geometry?.firstMaterial?.diffuse.mappingChannel)!)
                let hit = CGPoint(x: CGFloat(texcoords.x * image!.size.width), y: CGFloat(texcoords.y * image!.size.height))
                
                //                let color =  image!.getPixelColor(hit)
                
                let withEmoji = image!.placeImageOnImage(hit, top: NSImage(named: "obi")!)
                
                result.node.geometry?.firstMaterial?.diffuse.contents = image
                
                //                self.backgroundColor = color
                print("\(hit)")
                
                imageView.image = withEmoji
            } else {
                if let color = image as? NSColor {
                    self.layer?.backgroundColor = color.cgColor
                } else if let scene = image as? SKScene {
                    
                    
                    let texcoords = result.textureCoordinates(withMappingChannel: (result.node.geometry?.firstMaterial?.diffuse.mappingChannel)!)

                    print(texcoords)
                    
//                    let hit = CGPoint(
//                        x: texcoords.x * image.size.width,
//                        y: texcoords.y * image.size.height
//                    )
                    

//                    let emoji = SKLabelNode(text: "Theo")
//                    emoji.fontColor = NSColor().randomSolidHueColor()
//                    emoji.fontSize = CGFloat(drand48() * 100) + 24
                    
                    
//                    if let scene = scene as? VectorScene {
//                        scene.fakeTouch(hit)
//                    } else {
//                        let tex = SKTexture(imageNamed: "obi")
//                        let emoji = SKSpriteNode(texture: tex)
//                            //                    emoji.zRotation = CGFloat(drand48() * M_PI)
//                        emoji.position = hit
//                        scene.addChild(emoji)
//                    }
                    

                }
                
            }
        }
        

    }
}


extension NSView {
    func pinToParent() {
        guard let parent = self.superview else { return }
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: parent, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0))
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.left, relatedBy: NSLayoutRelation.equal, toItem: parent, attribute: NSLayoutAttribute.left, multiplier: 1, constant: 0))
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.right, relatedBy: NSLayoutRelation.equal, toItem: parent, attribute: NSLayoutAttribute.right, multiplier: 1, constant: 0))
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: parent, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0))
        
    }
}

