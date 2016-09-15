//
//  ProjectionViewController.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/13/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Cocoa
import SceneKit

class ProjectionViewController: NSViewController {

    var scnView:SCNView! {
        didSet {
            
            
            self.view.addSubview(scnView)
            scnView <- Edges(0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
    }

    var camera:SCNNode? {
        get {
            
            if let node = scnView.pointOfView {
                return node
            }


            return nil
        }
        
    }

    override func keyDown(with theEvent: NSEvent) {
//        super.keyDown(theEvent)
        if theEvent.keyCode == 123
        {
            //Left
            if let camera = camera {
                camera.position.x += 0.01
            }
            
        }
        else if theEvent.keyCode == 124
        {
            //Right
            if let camera = camera {
                camera.position.x -= 0.01
            }
        }
        else if theEvent.keyCode == 126
        {
            //Up
            if let camera = camera {
                camera.position.y += 0.01
            }
        }
        else if theEvent.keyCode == 125
        {
            //Down
            if let camera = camera {
                camera.position.y -= 0.01
            }
        }
        print("Key with number: \(theEvent.keyCode) was pressed")

    }
}
