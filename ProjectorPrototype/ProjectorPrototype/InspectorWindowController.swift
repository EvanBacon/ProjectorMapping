//
//  InspectorWindowController.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/13/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Cocoa

class InspectorWindowController: NSWindowController {

    convenience init(title:String) {
        self.init(windowNibName: "InspectorWindowController")
        self.window?.title = title
        shouldCascadeWindows = false
        windowFrameAutosaveName = "InspectorWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
contentViewController = InspectorViewController()
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    }
    
}
