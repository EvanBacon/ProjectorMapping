//
//  AppDelegate.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject {    
    @IBOutlet weak var window: NSWindow!
}

extension AppDelegate: NSApplicationDelegate {
    
    func application(sender: NSApplication, openFiles filenames: [String]) {
        
    }
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        LeapMotionManager.sharedInstance.run()
    }
}