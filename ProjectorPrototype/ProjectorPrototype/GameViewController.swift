//
//  GameViewController.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 8/30/16.
//  Copyright (c) 2016 Brix. All rights reserved.
//

import SceneKit
import QuartzCore
import SpriteKit


let DEBUG = true

class GameViewController: NSViewController {
    
    var projectionWindows:[ProjectionWindowController] = []
    
    var openProjectorWindows:[ProjectionWindowController]! {
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
    
    @IBOutlet var containerView: NSStackView!
    let imageView = SKView()
    
    var cursor:SCNNode!
    
    var startingPoint = CGPoint.zero
    var isGrabbing: Bool = false
    var isDrawing: Bool = false
    var paths: [SKShapeNode] = []
    //    var drawing: [[LeapDrawingIntent]] = [[]]
    var drawing: [SKEmitterNode] = []
    
    var redrawComplete: Bool = true
    var needsUpdate = false
    
    let distance: CGFloat = 8
    var gameView: GameView!
    
    let cameraOrbitRadius: CGFloat = 3
    var curXRadians = Float(0)
    var curYRadians = Float(0)
    var lastXRadians = Float(0)
    var lastYRadians = Int(0)
    
    var projectorScene:ProjectorScene!
}



extension GameViewController {
    @IBAction func newPerspective(_ sender: AnyObject) {
        addWindow(M_PI_2 * Double(openProjectorWindows.count))
    }
    
    @IBAction func toggleDebug(_ sender: AnyObject) {
        for view in containerView.subviews {
            if let view = view as? GameView {
                view.showsStatistics = !view.showsStatistics
            }
        }
        
        for controller in openProjectorWindows {
            
            if let view = controller.controller.scnView as? GameView {
                view.showsStatistics = !view.showsStatistics
            }
        }
    }
    
    @IBAction func toggleDebugOption(_ sender: NSMenuItem) {
        var option:SCNDebugOptions!
        switch sender.tag {
        case 1:
            option = SCNDebugOptions.showBoundingBoxes
            break
        case 2:
            option = SCNDebugOptions.showWireframe
            break
        default:
            option = SCNDebugOptions()
            break
        }
        
        for view in containerView.subviews {
            if let view = view as? GameView {
                view.debugOptions = option
            }
        }
        
        for controller in openProjectorWindows {
            if let view = controller.controller.scnView as? GameView {
                view.debugOptions = option
            }
        }
    }
    
    //    gameView.debugOptions = SCNDebugOptions.ShowBoundingBoxes
    
    
    @IBAction func rotateZ(_ sender: AnyObject) {
        projectorScene.mesh.eulerAngles.z += CGFloat(M_PI_2)
    }
    
    @IBAction func rotateX(_ sender: AnyObject) {
        projectorScene.mesh.eulerAngles.x += CGFloat(M_PI_2)
    }
    @IBAction func rotateY(_ sender: AnyObject) {
        projectorScene.mesh.eulerAngles.y += CGFloat(M_PI_2)
    }
    @IBAction func loadCube(_ sender: AnyObject) {
        // create a new scene
//        let scene = buildScene()
        
        projectorScene.setupMesh("cube")
        
//        setupSceneViews(scene)
    }
    @IBAction func loadGown(_ sender: AnyObject) {
        // create a new scene
//        let scene = buildScene("art.scnassets/untitled.dae")
        
        projectorScene.setupMesh()
        
//        setupSceneViews(scene)
    }
    @IBAction func loadSphere(_ sender: AnyObject) {
        // create a new scene
//        let scene = buildScene()
        projectorScene.setupMesh("sphere")
        
//        setupSceneViews(scene)
    }
}


extension GameViewController {
    func nameForAngle(_ angle:Double) -> String {
        switch angle {
        case 0:
            return "Front"
        case M_PI:
            return "Back"
        case M_PI_2:
            return "Right"
        case -M_PI_2:
            return "Left"
        default:
            return "\(floor(angle))°"
        }
    }
    func addWindow(_ angle:Double) {
        
        if openProjectorWindows.count >= 4 {
            return
        }
        
        if let view = containerView.subviews.first as? SCNView {
            if let scene = view.scene {
                let secondWindowController = ProjectionWindowController(scnView: projectorScene.addView(scene: scene, angle: angle), title: nameForAngle(angle))
                secondWindowController.showWindow(self)
                
                projectionWindows.append(secondWindowController)
            }
        }
    }
}

extension GameViewController {
    func setupCursor(_ root:SCNNode) {
        cursor = SCNNode(geometry: SCNSphere(radius: 0.05))
        cursor.geometry?.firstMaterial?.diffuse.contents = NSColor(red: 1, green: 0, blue: 0, alpha: 1)
        root.addChildNode(cursor)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectorScene = ProjectorScene()
        //        setupCursor(scene.rootNode)
        setupSceneViews(projectorScene)
        setupLoop()
        
        imageView.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
        //        imageView.presentScene(texture)
        
        self.view.addSubview(imageView)
    }
    
    func setAll() {
        
    }
}

extension GameViewController {
    
    fileprivate func setupSceneViews(_ scene:SCNScene) {
        for child in containerView.subviews {
            child.removeFromSuperview()
        }
        gameView = projectorScene.addView(scene: scene, angle: 0)
        
        self.containerView.addArrangedSubview(gameView)
        
        //        self.containerView.addArrangedSubview(addView(scene, angle: M_PI/2))
        //        self.containerView.addArrangedSubview(addView(scene, angle: M_PI))
        //        self.containerView.addArrangedSubview(addView(scene, angle: -M_PI/2))
    }
    
    fileprivate func buildMesh(_ scene:SCNScene, named:String?=nil) -> SCNNode {
        var mesh:SCNNode?
        
        if let name = named {
            if let node = scene.rootNode.childNode(withName: name, recursively: true) {
                mesh = node
            } else {
                if name == "cube" {
                    mesh = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
                    
                } else if name == "sphere" {
                    mesh = SCNNode(geometry: SCNSphere(radius: 1))
                    
                }
                /// Dope debuging
                let names = scene.rootNode.childNodes.map({
                    node in
                    node.name
                })
                print("Wrong mesh name, maybe you meant: \(names)")
            }
        } else {
            //            mesh = SCNNode(geometry: SCNBox(width: 2,height: 2,length: 2,chamferRadius: 0))
            
            mesh = SCNNode(geometry: SCNSphere(radius: 1))
        }
        
        return mesh ?? buildMesh(scene)
    }
    
    fileprivate func buildScene(_ named:String?=nil) -> SCNScene {
        let scene = SCNScene(withName: named)
        
        
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight().defaultOmni()
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        //         create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight().defaultAmbient()
        scene.rootNode.addChildNode(ambientLightNode)
        //
        
        return scene
    }
    
    
    func mat(_ color:NSColor) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = color
        
        return m
        
    }
    
    fileprivate func setupLoop() {
        LeapMotionManager.sharedInstance.addListener(self)
        
        _ = Timer.scheduledTimer(timeInterval: 1/16, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
    }
    
    func update() {
        projectorScene.mesh.runAction(SCNAction.fadeIn(duration: 0.000001))
        if needsUpdate {
            needsUpdate = false
            renderDrawing()
        }
    }
    
    func updateDrag(_ translation: CGPoint, end: Bool=false) {
        var xRadians = GLKMathDegreesToRadians(Float(translation.x))
        //        var yRadians = GLKMathDegreesToRadians(Float(translation.y))
        
        // Rotate camera
        // -- Get x and y radians
        xRadians = (xRadians / 10) + curXRadians
        //        yRadians = (yRadians / 10) + curYRadians
        
        
        //        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: CGFloat(yRadians))
        //        lastXRadians = event.absoluteX
        //        lastYRadians = event.absoluteY
        
        if end {
            
            //                    let dif = xRadians + (( lastXRadians - xRadians ))
            //
            //                    let a = SCNAction.rotateToAxisAngle(SCNVector4Make(0, 1, 0, CGFloat(dif)), duration: 5)
            //                    a.timingMode = .EaseOut
            //                    self.mesh.runAction(a)
            
            curXRadians = xRadians
            
            
        } else {
            //            mesh.rotation = SCNVector4Make(0, 1, 0, CGFloat(xRadians))
            
        }
        lastXRadians = xRadians
    }
}

extension GameViewController: LeapMotionManagerDelegate {
    
    func leapMotionManagerDidUpdateFrame(_ frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                return
            }
            
            if hands.count > 0 {
                
                if let scene = projectorScene.texture as? VelocityScene {
                    scene.isPaused = (hands.count != 1)
                }
                
                
                if let hand = hands.first {
                    
                    if hand.pastCenter {
                        addDrawing(hand)
                    } else {
                        endDrawing()
                    }
                    
                    
                    isGrabbing = hand.grabbing
                    isDrawing = hand.pinching
                    
                }
            }
        }
    }
    
    func rotateGesture(_ gesture: LeapCircleGesture) {
        
    }
    
    func swipeGesture(_ gesture: LeapSwipeGesture) {
        //        let direction = gesture.direction
        //        let speed = gesture.speed
        //        let position = gesture.position
        //        let id = gesture.id
        //
        //
        //        switch gesture.state {
        //        case LEAP_GESTURE_STATE_START:
        //            break
        //        case LEAP_GESTURE_STATE_UPDATE:
        //            break
        //        case LEAP_GESTURE_STATE_STOP:
        //            break
        //        case LEAP_GESTURE_STATE_INVALID:
        //            break
        //        default:
        //            fatalError("WTF")
        //            break
        //        }
        
        
        
        //        print(direction, direction.direction2D, speed, position, id, gesture.state)
    }
    
    func keyTapGesture(_ gesture: LeapKeyTapGesture) {
    }
    
    func screenTapGesture(_ gesture: LeapScreenTapGesture) {
    }
}

extension GameViewController {
    
   
    func endDrawing() {
        //// Touch up
        
        if let scene = projectorScene.texture as? VelocityScene {
            scene.touchPoint = nil
        }
        
        //        if let generator = drawing.last {
        //            generator.paused = true
        //        }
        //
        //        let generator = self.generator()
        //
        //        drawing.append(generator)
        
        
        
        
        //        drawing.append([])
    }
    
    func addDrawing(_ hand: LeapHand) {
        let p = adjustedPoint(hand.palmPosition)
        guard let position = mappedPoint(p) else {
            
            
            endDrawing()
            
            return
            
        }
        let strength = hand.palmVelocity.magnitude
        
        updatePan(position, velocity: strength, strength: hand.grabStrength)
    }
    
    func mappedPoint(_ point: CGPoint) -> CGPoint? {
        
        //        let p = self.convertPoint(point, fromView: nil)
        let hitResults = gameView.hitTest(point, options: [SCNHitTestOption.firstFoundOnly: true])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: SCNHitTestResult = hitResults[0]
            
            //            cursor.position = result.worldCoordinates
            //            print(result.worldNormal)
            
            if let mappingChannel = result.node.geometry?.firstMaterial?.diffuse.mappingChannel {
                let texcoords = result.textureCoordinates(withMappingChannel: mappingChannel)
                
                let hit = CGPoint(x: CGFloat(texcoords.x * projectorScene.texture.size.width), y: CGFloat(texcoords.y * projectorScene.texture.size.height))
                return hit
            }
        }
        
        return nil
    }
    
    func remapForPoint(_ point: CGPoint) -> CGPoint? {
        
        //        let p = self.convertPoint(point, fromView: nil)
        let hitResults = gameView.hitTest(point, options: [SCNHitTestOption.firstFoundOnly: true])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: SCNHitTestResult = hitResults[0]
            
            cursor.position = result.worldCoordinates
            print(result.worldNormal)
            
            if let mappingChannel = result.node.geometry?.firstMaterial?.diffuse.mappingChannel {
                let texcoords = result.textureCoordinates(withMappingChannel: mappingChannel)
                
                let hit = CGPoint(x: CGFloat(texcoords.x * projectorScene.texture.size.width), y: CGFloat(texcoords.y * projectorScene.texture.size.height))
                return hit
            }
        }
        
        return nil
    }
    
    
    func updatePan(_ position: CGPoint, velocity: Float, strength: Float) {
        //        if let generator = drawing.last {
        //            print(velocity/400)
        //            generator.particleColorSequence = nil
        //            generator.particleColorBlendFactor = 1.0
        //
        //            generator.particleBirthRate = 100 + CGFloat(400 * strength)
        ////            generator.particleScale = CGFloat(strength)
        //            generator.particleColor = NSColor(hue: CGFloat(velocity/400), saturation: 1, brightness: 1, alpha: 1)
        //            generator.paused = false
        //            generator.position = position
        //        }
        
        //        if let scene = texture as? VectorScene {
        //            scene.fakeTouch(position)
        //        }
        
        if let scene = projectorScene.texture as? VelocityScene {
            scene.fakeTouch(position)
        }
        
        
        
        //        let position = (hand.index?.tipPosition.toPoint())!
        //        let intent = LeapDrawingIntent(strength: velocity, position: position, color: NSColor.greenColor())
        //        drawing[drawing.count - 1].append(intent)
        needsUpdate = true
    }
    
    func renderDrawing() {
        
        if redrawComplete {
            self.redrawComplete = false
            DispatchQueue.main.async(execute: {
                
                //                if let generator = self.drawing.last {
                //                    generator.position =
                ////                    if let point = line.last {
                ////                        self.generativeParticle.position = point.position
                ////                    }
                //                }
                
                //                if self.texture.children.count == self.drawing.count {
                //                    self.texture.children.last?.removeFromParent()
                //                }
                //                //            self.texture.enumerateChildNodesWithName("line", usingBlock: { node, stop in
                //                //                node.removeFromParent()
                //                //
                //                //            })
                //
                //                let line = self.drawing.last!
                //
                //                if let path = self.buildPath(line) {
                //                    let shapeNode = SKShapeNode()
                //                    shapeNode.path = path
                //                    shapeNode.name = "line"
                //                    shapeNode.strokeColor = NSColor.orangeColor()
                //                    shapeNode.lineWidth = 6
                //                    shapeNode.zPosition = 1
                //                    shapeNode.blendMode = SKBlendMode.Alpha
                //
                //                    self.texture.addChild(shapeNode)
                //
                //                }
                
                
                self.redrawComplete = true
                
            })
        }
        
    }
    
    
    func buildPath(_ line: [LeapDrawingIntent]) -> CGPath? {
        //1
        if line.count <= 1 {
            return nil
        }
        
        
        //2
        let ref = CGMutablePath()
        
        //3
        for i in 0..<line.count {
            if let p = line[i].position {
                
                //4
                if i == 0 {
                    ref.move(to: p)
                } else {
                    ref.addLine(to: p)
                    
                }
            }
        }
        
        return ref
        
    }
    
    func adjustedPoint(_ point: LeapVector) -> CGPoint {
        
        let appWidth = self.gameView.frame.width
        let appHeight = self.gameView.frame.height
        
        if let currentFrame = LeapMotionManager.sharedInstance.currentFrame {
            let iBox = currentFrame.interactionBox()
            
            
            let normalizedPoint = iBox?.normalizePoint(point, clamp: true).toPoint()
            
            let appX = (normalizedPoint?.x)! * appWidth
            let appY = (normalizedPoint?.y)! * appHeight
            //            //The z-coordinate is not used
            //
            return CGPoint(x: appX, y: appY)
        } else {
            return CGPoint.zero
        }
    }
}
