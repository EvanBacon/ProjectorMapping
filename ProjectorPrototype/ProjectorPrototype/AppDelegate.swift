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
    let inspector = InspectorWindowController(title: "Inspector")

    var windows:[NSWindow] = []
}

extension AppDelegate:NSWindowDelegate {
    
    
    func windowDidBecomeKey(_ notification: Notification) {
        
//        if let window = notification.object as? NSWindow {
        
//            if window.respondsToSelector(<#T##aSelector: Selector##Selector#>)
//        }
        
        if let controller = inspector.contentViewController as? InspectorViewController {
            controller.reloadPopup()
        }
        print(notification)

    }
}

extension AppDelegate: NSApplicationDelegate {

    func application(_ sender: NSApplication, openFiles filenames: [String]) {
        
    }
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        LeapMotionManager.sharedInstance.run()
        
        inspector.showWindow(self)
window.delegate = self
        
        
    }
    
//    @IBAction func menuAction(sender: AnyObject) {
//        if let storyboard = NSStoryboard(name: "Main", bundle: nil) {
//            let controller = storyboard.instantiateControllerWithIdentifier("VC1") as NSViewController
//            
//            if let window = NSApplication.sharedApplication().mainWindow {
//                window.contentViewController = controller // just swap
//            }
//        }
//    }
    
}
