//
//  ProjectionWindowController.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/13/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Cocoa
import SceneKit

class ProjectionWindowController: NSWindowController {

    var controller:ProjectionViewController!
    var title:String!
    convenience init(scnView:SCNView, title:String) {
        self.init(windowNibName: "ProjectionWindowController")
        controller = ProjectionViewController()
        controller.scnView = scnView
        self.title = title
        
        shouldCascadeWindows = false
        
        windowFrameAutosaveName = title
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.contentViewController = controller
        
        self.window?.title = title
        print(title)
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
