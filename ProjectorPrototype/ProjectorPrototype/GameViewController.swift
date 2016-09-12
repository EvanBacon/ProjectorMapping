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

    @IBOutlet var containerView: NSStackView!
    let imageView = SKView()

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
    

    var texture: SKScene!
    
    var mesh: SCNNode!
    let cameraOrbitRadius: CGFloat = 3
    var curXRadians = Float(0)
    var curYRadians = Float(0)
    var lastXRadians = Float(0)
    var lastYRadians = Int(0)

    var generativeParticle: SKEmitterNode!
}

extension NSView {
    func pinToParent() {
        guard let parent = self.superview else { return }
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))

        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0))
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0))
        
        parent.addConstraint(NSLayoutConstraint(item: self, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: parent, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
        
    }
}

extension GameViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = buildScene()
        
        
        let res: CGFloat = 1024
        texture = VectorScene(size: CGSize(width: res, height: res))
        texture.scaleMode = .AspectFit
        texture.backgroundColor = NSColor.whiteColor()
    
        
        
//        let scene = buildScene()
        
        setupMesh(scene)
        
        setupSceneViews(scene)
        
        setupLoop()
        
        
        
        imageView.frame = CGRect(x: 0,y: 0,width: 100,height: 100)
//        imageView.image = texture
//        imageView.presentScene(texture)
        self.view.addSubview(imageView)
    }
}

extension GameViewController {
  
    private func setupCamera(scene:SCNScene) -> SCNNode {
        let min = mesh.min()
        let size = mesh.size()
        let center = mesh.center
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: center.x, y: center.y , z: min.z + size.z + 2)
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.zNear = 0.0001
        
        let largestSide = Double(max(size.x, max(size.y, size.z))) * 1.1
        cameraNode.camera?.zFar = (largestSide + 5) * 100 //Dont even think about it
//        cameraNode.camera?.xFov = largestSide
//        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.orthographicScale = largestSide / 2
        let lookAt = SCNLookAtConstraint(target:mesh)
////        lookAt.gimbalLockEnabled = true
//        cameraNode.constraints = [lookAt]
        return cameraNode
    }
    
    private func setupSceneViews(scene:SCNScene) {
        gameView = addView(scene, angle: 0)
        self.containerView.addArrangedSubview(gameView)

        self.containerView.addArrangedSubview(addView(scene, angle: M_PI/2))
//        self.containerView.addArrangedSubview(addView(scene, angle: M_PI))
//        self.containerView.addArrangedSubview(addView(scene, angle: -M_PI/2))
    }
  
    private func buildMesh(scene:SCNScene, named:String?=nil) -> SCNNode {
        var mesh:SCNNode?
        
        if let name = named {
            if let node = scene.rootNode.childNodeWithName(name, recursively: true) {
                mesh = node
            } else {
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
    
    private func buildScene(named:String?=nil) -> SCNScene {
        let scene = SCNScene(withName: named)
        
    
//        // create and add a light to the scene
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight().defaultOmni()
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
//        scene.rootNode.addChildNode(lightNode)
//        
//        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight().defaultAmbient()
//        scene.rootNode.addChildNode(ambientLightNode)
//        
        
        return scene
    }
    
    
    func mat(color:NSColor) -> SCNMaterial {
        let m = SCNMaterial()
        m.diffuse.contents = color
        return m
        
    }
    private func setupMesh(scene:SCNScene) {
        mesh = buildMesh(scene, named: "Cube")
        mesh.geometry?.firstMaterial?.diffuse.contents = texture
//        self.mesh.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 3)))

        scene.rootNode.addChildNode(mesh)
        mesh.resetTransforms()

//        mesh.centerPivot()
    }
    
    private func setupGameView(scene:SCNScene, camera:SCNNode) -> GameView {
        let gameView = GameView(frame: self.view.frame)
        gameView.translatesAutoresizingMaskIntoConstraints = false
        // set the scene to the view
        gameView.scene = scene
        
        // allows the user to manipulate the camera
        gameView.allowsCameraControl = DEBUG
        
        // show statistics such as fps and timing information
        gameView.showsStatistics = DEBUG
        
        // configure the view
        gameView.backgroundColor = NSColor.grayColor()
        
//        gameView.debugOptions = SCNDebugOptions.ShowBoundingBoxes
        gameView.delegate = self
        gameView.playing = true
        gameView.overlaySKScene = CursorScene(size: gameView.frame.size)
        gameView.overlaySKScene!.hidden = false
        gameView.overlaySKScene!.scaleMode = .AspectFill
        gameView.autoenablesDefaultLighting = true
        
        scene.rootNode.addChildNode(camera)
        gameView.pointOfView = camera

        return gameView
    }
    
    private func addView(scene:SCNScene, angle:Double) -> GameView {
        
        // create and add a camera to the scene
        let camera = setupCamera(scene)
        
        let meshSize = mesh.size()
        camera.rotation = SCNVector4(0, 1, 0, angle + M_PI)
        
        let y = camera.position.y
        camera.position = getMoveVectorForAngle(angle, distance: Double(camera.position.z))
        camera.position.y = y
        

        
        print("camera", camera.position, angle, camera.rotation)
        let sceneView = setupGameView(scene, camera: camera)
        
        return sceneView
    }
    
    private func setupLoop() {
        LeapMotionManager.sharedInstance.addListener(self)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1/16, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
    }
    
    func update() {
        self.mesh.runAction(SCNAction.fadeInWithDuration(0.000001))
        if needsUpdate {
            needsUpdate = false
            renderDrawing()
        }
    }
    
   
    func setupParticle() {
        let path = NSBundle.mainBundle().pathForResource("Paint", ofType: "sks")
        
        if let generativeParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as? SKEmitterNode {
            
            self.generativeParticle = generativeParticle
            generativeParticle.position = CGPoint(x: texture.size.width/2, y: texture.size.height/2)
            generativeParticle.name = "rainParticle"
            generativeParticle.targetNode = texture
            
            
            //            texture.addChild(generativeParticle)
        }
    }
    
    func updateDrag(translation: CGPoint, end: Bool=false) {
        
        //        let translation = CGPoint(x: event.deltaX, y: event.deltaY)
        var xRadians = GLKMathDegreesToRadians(Float(translation.x))
        //        var yRadians = GLKMathDegreesToRadians(Float(translation.y))
        
        // Rotate camera
        // -- Get x and y radians
        xRadians = (xRadians / 10) + curXRadians
        //        yRadians = (yRadians / 10) + curYRadians
        
        // -- Limit rotation to prevent looking 360 degrees vertically
        //        yRadians = max(Float(-M_PI_2), min(Float(M_PI_2), yRadians))
        
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

extension GameViewController {
    private func getMoveVectorForAngle(angle: Double = 0, distance: Double = 15) -> SCNVector3 {
        return getSphericalCoords(0, tVal: angle, rVal: distance)
    }

    
    func getSphericalCoords(sVal: Double, tVal: Double, rVal: Double) -> SCNVector3 {
        return SCNVector3(-(cos(sVal) * sin(tVal) * rVal),
                          sin(sVal) * rVal,
                          -(cos(sVal) * cos(tVal) * rVal))
    }
}

extension GameViewController: SCNSceneRendererDelegate {
    func renderer(renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: NSTimeInterval) {
    }
}

extension GameViewController: LeapMotionManagerDelegate {

    func leapMotionManagerDidUpdateFrame(frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                return
            }
            for hand in hands {

//                if hand.grabbing {
//                    if !isGrabbing {
//                        startingPoint = adjustedPoint(hand.palmPosition)
//                        
//                       
//
//                    } else {
//                        updateDrag(adjustedPoint( hand.palmPosition) - startingPoint)
//                    }
//                    //                    print( hand.palmPosition - startingPoint )
//
//
//                } else {
//                    if isGrabbing {
//                        updateDrag(adjustedPoint( hand.palmPosition) - startingPoint, end: true)
//                        startingPoint = CGPoint.zero
//                    }
//                }

//                if hand.pinching {
               
//                    if !isDrawing {
//                        if let generator = drawing.last {
//                            texture.addChild(generator)
//                        }
//                    }
                
                    addDrawing(hand)
//                } else {
//                    if isDrawing {
//                        //End Line
//                        endDrawing()
//                    }
//                }
                isGrabbing = hand.grabbing
                isDrawing = hand.pinching
                break
            }
        }
    }

    func rotateGesture(gesture: LeapCircleGesture) {

    }

    func swipeGesture(gesture: LeapSwipeGesture) {
        let direction = gesture.direction
        let speed = gesture.speed
        let position = gesture.position
        let id = gesture.id


        switch gesture.state {
        case LEAP_GESTURE_STATE_START:
            break
        case LEAP_GESTURE_STATE_UPDATE:
            break
        case LEAP_GESTURE_STATE_STOP:
            break
        case LEAP_GESTURE_STATE_INVALID:
            break
        default:
            fatalError("WTF")
            break
        }



        print(direction, direction.direction2D, speed, position, id, gesture.state)
    }

    func keyTapGesture(gesture: LeapKeyTapGesture) {

    }

    func screenTapGesture(gesture: LeapScreenTapGesture) {

    }

}

extension GameViewController {

    func generator() -> SKEmitterNode {
        return self.generativeParticle.copy() as! SKEmitterNode
    }

    func endDrawing() {
        if let generator = drawing.last {
            generator.paused = true
        }

        let generator = self.generator()

        drawing.append(generator)
//        drawing.append([])
    }

    func addDrawing(hand: LeapHand) {
        let p = adjustedPoint(hand.palmPosition)
        guard let position = mappedPoint(p) else { return }
        let strength = hand.palmVelocity.magnitude

        updatePan(position, velocity: strength, strength: hand.grabStrength)
    }

    
    
    func mappedPoint(point: CGPoint) -> CGPoint? {
        
        //        let p = self.convertPoint(point, fromView: nil)
        let hitResults = gameView.hitTest(point, options: [SCNHitTestFirstFoundOnlyKey: true])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            if let mappingChannel = result.node!.geometry?.firstMaterial?.diffuse.mappingChannel {
                let texcoords = result.textureCoordinatesWithMappingChannel(mappingChannel)
                
                let hit = CGPointMake(CGFloat(texcoords.x * texture.size.width), CGFloat(texcoords.y * texture.size.height))
                return hit
            }
            
            
        }
        
        return nil
    }


    func updatePan(position: CGPoint, velocity: Float, strength: Float) {
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
        
        if let scene = texture as? VectorScene {
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
            dispatch_async(dispatch_get_main_queue(), {

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


    


    func buildPath(line: [LeapDrawingIntent]) -> CGPathRef? {
        //1
        if line.count <= 1 {
            return nil
        }


        //2
        let ref = CGPathCreateMutable()

        //3
        for i in 0..<line.count {
            let p = line[i].position

            //4
            if i == 0 {
                CGPathMoveToPoint(ref, nil, p.x, p.y)
            } else {
                CGPathAddLineToPoint(ref, nil, p.x, p.y)
            }
        }

        return ref

    }

    func adjustedPoint(point: LeapVector) -> CGPoint {

        let appWidth = self.gameView.frame.width
        let appHeight = self.gameView.frame.height

        if let currentFrame = LeapMotionManager.sharedInstance.currentFrame {
            let iBox = currentFrame.interactionBox()


            let normalizedPoint = iBox.normalizePoint(point, clamp: true).toPoint()

            let appX = normalizedPoint.x * appWidth
            let appY = (normalizedPoint.y) * appHeight
            //            //The z-coordinate is not used
            //
            return CGPoint(x: appX, y: appY)
        } else {
            return CGPoint.zero
        }
    }
}
