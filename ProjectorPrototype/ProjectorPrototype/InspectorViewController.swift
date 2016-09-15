//
//  InspectorViewController.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/13/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Cocoa
import SceneKit
protocol InspectorDelegate {
    func inspector(_ inspector:InspectorViewController, didUpdateOrientation orientation:(position:SCNVector3, rotation:SCNVector3))
}

protocol InspectorDataSource {
    func inspectorDidRequestCamera(_ inspector:InspectorViewController) -> SCNNode
}

protocol InspectorWindowDataSource {
    func inspectorDidRequestWindowNamed(_ inspector:InspectorViewController) -> NSWindow
    
    func inspectorDidRequestWindowNames(_ inspector:InspectorViewController) -> [String]
}

class InspectorViewController: NSViewController {

    var perspectives:[ProjectionWindowController]! {
        get {
            
            var a = [ProjectionWindowController]()
            for window in NSApplication.shared().windows {
                
                if let window = window.windowController as? ProjectionWindowController {
                    a.append(window)
                }
            }
            
            return a
            
        }
    }
    
    
    @IBAction func popUpButtonAction(_ sender: NSPopUpButton) {
        
        for a in perspectives {
            if let title = a.window?.title {
                if title == sender.selectedItem?.title {
                    cameraNode = a.controller.camera
                    updateWithCamera(cameraNode.presentation)
                }

            }
        }
        
        
    }
    @IBOutlet weak var popUp: NSPopUpButton!
    var delegate:InspectorDelegate!
    
    var windowDataSource:InspectorWindowDataSource! {
        didSet {
            reloadPopup()
        }
    }
    
    func reloadPopup() {

        popUp.removeAllItems()
        
        
        for a in perspectives {
            if let title = a.window?.title {
                popUp.addItem(withTitle: title)
            }
        }
//        popUp.addItemsWithTitles(["Front", "Left", "Back", "Right"])
        //        popUp.addItemsWithTitles(windowDataSource.inspectorDidRequestWindowNames(self))
        
        
    }

    
    
    var dataSource:InspectorDataSource! {
        didSet {
            reload()
        }
    }
    
    func reload() {
        updateWithCamera(dataSource.inspectorDidRequestCamera(self))
    }
    
    func updateWithCamera(_ camera:SCNNode) {
        
        inputPosX.stringValue = "\(camera.position.x)"
        inputPosY.stringValue = "\(camera.position.y)"
        inputPosZ.stringValue = "\(camera.position.z)"
        
        inputRotX.stringValue = "\(camera.eulerAngles.x)"
        inputRotY.stringValue = "\(camera.eulerAngles.y)"
        inputRotZ.stringValue = "\(camera.eulerAngles.z)"
        
    }
    var cameraNode:SCNNode!
    @IBAction func textInputAction(_ sender: NSTextField) {
        
        
        
        var rotation = SCNVector3()
        var position = SCNVector3()
        
        
        if let camera = cameraNode {
            rotation = camera.eulerAngles
            position = camera.position
        }
        
        
        
        let value = CGFloat((sender.stringValue as NSString).doubleValue)
        switch sender {
        case inputPosX:
            position.x = value
            break
        case inputPosY:
            position.y = value
            break
        case inputPosZ:
            position.z = value
            break
        case inputRotX:
            rotation.x = value
            break
        case inputRotY:
            rotation.y = value
            break
        case inputRotZ:
            rotation.z = value
            break
        default:
            break
        }
        
     
        if let selected = popUp.selectedItem {
            for a in perspectives {
                if let title = a.window?.title {
                    if title == selected.title {
                        a.controller.camera?.position = position
                        a.controller.camera?.eulerAngles = rotation
                        
                    }
                    
                }
            }

        }
        
    }
    
    @IBOutlet weak var inputRotZ: NSTextField!
    @IBOutlet weak var inputRotY: NSTextField!
    @IBOutlet weak var inputRotX: NSTextField!
    @IBOutlet weak var inputPosZ: NSTextField!
    @IBOutlet weak var inputPosY: NSTextField!
    @IBOutlet weak var inputPosX: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        reloadPopup()
    }
    
}
