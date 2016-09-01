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

extension SCNNode {
    
    func size() -> SCNVector3 {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        getBoundingBoxMin(&min, max: &max)
        
        return max - min
    }
    func min() -> SCNVector3 {
        var min = SCNVector3Zero
        var max = SCNVector3Zero
        getBoundingBoxMin(&min, max: &max)
        
        return min
    }
    
    func centerPivot() {
        var minVec = SCNVector3Zero
        var maxVec = SCNVector3Zero
        if getBoundingBoxMin(&minVec, max: &maxVec) {
            let bound = SCNVector3(
                x: maxVec.x - minVec.x,
                y: maxVec.y - minVec.y,
                z: maxVec.z - minVec.z)
            
            pivot = SCNMatrix4MakeTranslation(bound.x / 2, bound.y / 2, bound.z / 2)
        }
    }
    
}

struct Uniforms {
    var coord:vector_float2
}

func + (lhs:LeapVector, rhs:LeapVector) -> LeapVector {
    return LeapVector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}
func - (lhs:LeapVector, rhs:LeapVector) -> LeapVector {
    return LeapVector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

func + (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
func - (lhs:CGPoint, rhs:CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}


extension GameViewController: LeapMotionManagerDelegate {
    
    func leapMotionManagerDidUpdateFrame(frame: LeapFrame) {
        if let hands = frame.hands as? [LeapHand] {
            if hands.count <= 0 {
                return
            }
            for hand in hands {
                
                if hand.grabbing {
                    if !isGrabbing {
                        startingPoint = adjustedPoint(hand.palmPosition)
                    } else {
                        updateDrag(adjustedPoint( hand.palmPosition) - startingPoint)
                    }
//                    print( hand.palmPosition - startingPoint )
                    
                    
                } else {
                    if isGrabbing {
                        updateDrag(adjustedPoint( hand.palmPosition) - startingPoint, end: true)
                        startingPoint = CGPointZero
                    }
                }
                
                if hand.pinching {
                    addDrawing(hand)
                } else {
                    if isDrawing {
                        //End Line
                        endDrawing()
                    }
                }
                isGrabbing = hand.grabbing
                isDrawing = hand.pinching
                break
            }
        }
    }
    
    func endDrawing() {
        drawing.append([])
    }
    
    func addDrawing(hand:LeapHand) {
        let p = adjustedPoint(hand.palmPosition)
        guard let position = mappedPoint(p) else { return }
        
        
        let strength = hand.palmVelocity.magnitude
        //        let position = (hand.index?.tipPosition.toPoint())!
        let intent = LeapDrawingIntent(strength: strength, position: position, color: NSColor.greenColor())
        
        drawing[drawing.count - 1].append(intent)
        
        needsUpdate = true
    }
    
    func renderDrawing() {
        
        if redrawComplete {
            self.redrawComplete = false
            dispatch_async(dispatch_get_main_queue(),{
                
                if self.texture.children.count == self.drawing.count {
                    self.texture.children.last?.removeFromParent()
                }
                //            self.texture.enumerateChildNodesWithName("line", usingBlock: { node, stop in
                //                node.removeFromParent()
                //
                //            })
                
                let line = self.drawing.last!
                
                if let path = self.buildPath(line) {
                    let shapeNode = SKShapeNode()
                    shapeNode.path = path
                    shapeNode.name = "line"
                    shapeNode.strokeColor = NSColor.orangeColor()
                    shapeNode.lineWidth = 6
                    shapeNode.zPosition = 1
                    shapeNode.blendMode = SKBlendMode.Alpha;

                    self.texture.addChild(shapeNode)
                    
                }
                
                
                self.redrawComplete = true
                
            })
        }
        
    }
    
    func mappedPoint(point:CGPoint) -> CGPoint? {
        
        //        let p = self.convertPoint(point, fromView: nil)
        let hitResults = gameView.hitTest(point, options: [SCNHitTestFirstFoundOnlyKey: true])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            let texcoords = result.textureCoordinatesWithMappingChannel((result.node!.geometry?.firstMaterial?.diffuse.mappingChannel)!)
            let hit = CGPointMake(CGFloat(texcoords.x * texture!.size.width), CGFloat(texcoords.y * texture!.size.height))
            
            return hit
        }
        
        return nil
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
    
    func adjustedPoint(point:LeapVector) -> CGPoint {
        
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
            return CGPointZero
        }
    }
    
}
class GameViewController: NSViewController {
    
    var startingPoint = CGPointZero
    var isGrabbing:Bool = false
    var isDrawing:Bool = false
    var paths:[SKShapeNode] = []
    var drawing:[[LeapDrawingIntent]] = [[]]
    
    var redrawComplete:Bool = true
    
    var needsUpdate = false
    var texture:SKScene!
    
    let distance:CGFloat = 8
    @IBOutlet weak var gameView: GameView!
    let cameraNode = SCNNode()
    
    var mesh:SCNNode!
    let cameraOrbitRadius:CGFloat = 3
    
    @IBOutlet weak var altView: GameView!
    override func awakeFromNib(){
        super.awakeFromNib()
        
        //        let wc = NSWindowController(windowNibName: "Mirror")
        //         wc.showWindow(self)
        
        
        // create a new scene
        //        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //        let scene = SCNScene(named: "art.scnassets/Stormtrooper.scn")!
        let scene = SCNScene()
        
        // create and add a camera to the scene
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: distance)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = NSColor.darkGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)
        
        
        
        let res:CGFloat = 2048
        texture = SKScene(size: CGSize(width: res, height: res))
        texture.backgroundColor = NSColor.whiteColor()
        
        // retrieve the ship node
        
        //        let armature = scene.rootNode.childNodeWithName("Armature", recursively: true)!
        
        //        mesh = scene.rootNode.childNodeWithName("Stormtrooper", recursively: true)!
        mesh = SCNNode(geometry: SCNSphere(radius: 1))
        mesh.geometry?.firstMaterial?.diffuse.contents = texture
        scene.rootNode.addChildNode(mesh)
        
        //        mesh.geometry?.firstMaterial?.diffuse.contents = texture
        let min = mesh.presentationNode.min()
        let size = mesh.presentationNode.size()
        //        mesh.centerPivot()
        mesh.position = SCNVector3Zero
        
        
        let lookAt = SCNLookAtConstraint(target:mesh)
        lookAt.gimbalLockEnabled = true
        cameraNode.constraints = [lookAt]
        
        
        // set the scene to the view
        self.gameView!.scene = scene
        
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        
        // configure the view
        self.gameView!.backgroundColor = NSColor.blackColor()
        
        
        gameView.delegate = self
        
        gameView.playing = true
        
        
        
        /* Set the scale mode to scale to fit the window */
        //            skScene.scaleMode = .AspectFill
        //            skScene.size = self.view.frame.size
        
        self.gameView.overlaySKScene = CursorScene(size: gameView.frame.size)
        self.gameView.overlaySKScene!.hidden = false;
        self.gameView.overlaySKScene!.scaleMode = .ResizeFill
        
        // create and add a camera to the scene
        let altCameraNode = SCNNode()
        altCameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(altCameraNode)
        
        altCameraNode.camera?.usesOrthographicProjection = true
        //        altCameraNode.camera?.orthographicScale = Double(size.z * 0.5)
        NSLog("\(size)", "")
        // place the camera
        
        // set the scene to the view
        altView.scene = scene
        
        // allows the user to manipulate the camera
        altView.allowsCameraControl = false
        
        // show statistics such as fps and timing information
        altView.showsStatistics = true
        
        // configure the view
        altView.backgroundColor = NSColor.blackColor()
        altView.pointOfView = altCameraNode
        
        let lookAtAlt = SCNLookAtConstraint(target:mesh)
        lookAtAlt.gimbalLockEnabled = true
        altCameraNode.constraints = [lookAtAlt]
        
        
        altCameraNode.position = getMoveVectorForAngle(Float(M_PI_2), distance: Float(distance))
        altCameraNode.position.y = min.z + (size.z/2)
        
        
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.orthographicScale = (altCameraNode.camera?.orthographicScale)!
        
        mesh.rotation = SCNVector4Make(0, 1, 0, CGFloat(0))

        
        //        mesh.geometry?.firstMaterial?.shaderModifiers = [
        //
        //            SCNShaderModifierEntryPointSurface:
        //                    "uniform float Scale = 12.0;\n" +
        //                    "uniform float Width = 0.5;\n" +
        //                    "uniform float Blend = 0.0;\n" +
        //                    "vec2 position = fract(_surface.diffuseTexcoord * Scale);" +
        //                    "float f1 = clamp(position.y / Blend, 0.0, 1.0);" +
        //                    "float f2 = clamp((position.y - Width) / Blend, 0.0, 1.0);" +
        //                    "f1 = f1 * (1.0 - f2);" +
        //                    "f1 = f1 * f1 * 2.0 * (3. * 2. * f1);" +
        //                    "_surface.bump = mix(vec4(1.0), vec4(0.0), f1);"
        //        ]
        
        LeapMotionManager.sharedInstance.addListener(self)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(1/16, target: self, selector: #selector(GameViewController.update), userInfo: nil, repeats: true)
        
        
    }
    
    func update() {
        self.mesh.removeAllActions()
        self.mesh.runAction(SCNAction.fadeInWithDuration(0.000001))
        
        if needsUpdate {
            needsUpdate = false
            renderDrawing()
        }
    }
    
    private func getMoveVectorForAngle(angle:Float = 0, distance:Float = 15) -> SCNVector3 {
        return getSphericalCoords(0, t: angle, r: distance)
    }
    
    var curXRadians = Float(0)
    var curYRadians = Float(0)
    var lastXRadians = Int(0)
    var lastYRadians = Int(0)
    
    //    override func mouseDragged(event: NSEvent) {
    //        updateDrag(event)
    //    }
    //
    //    override func mouseUp(event: NSEvent) {
    //        updateDrag(event)
    //    }
    
    func updateDrag(translation:CGPoint, end:Bool=false) {
        
        //        let translation = CGPoint(x: event.deltaX, y: event.deltaY)
        var xRadians = GLKMathDegreesToRadians(Float(translation.x))
        //        var yRadians = GLKMathDegreesToRadians(Float(translation.y))
        
        // Rotate camera
        // -- Get x and y radians
        xRadians = (xRadians / 10) + curXRadians
        //        yRadians = (yRadians / 10) + curYRadians
        
        // -- Limit rotation to prevent looking 360 degrees vertically
        //        yRadians = max(Float(-M_PI_2), min(Float(M_PI_2), yRadians))
        
        mesh.rotation = SCNVector4Make(0, 1, 0, CGFloat(xRadians))
        //        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: CGFloat(yRadians))
        //        lastXRadians = event.absoluteX
        //        lastYRadians = event.absoluteY
        
                if end {
        curXRadians = xRadians
        //            curYRadians = yRadians
                }
    }
    
    func getSphericalCoords(s: Float, t: Float, r: Float) -> SCNVector3 {
        return SCNVector3(-(cos(s) * sin(t) * r),
                          sin(s) * r,
                          -(cos(s) * cos(t) * r))
    }
    
}

extension NSImage {
    func getPixelColor(pos: CGPoint) -> NSColor {
        
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        var r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        var g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        var b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        //        var a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        var a = CGFloat(1.0)
        
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func placeImageOnImage(pos: NSPoint, top:NSImage) -> NSImage {
        
        let fullyRect = NSRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let rect = NSRect(x: pos.x - 25, y: (self.size.height - pos.y) - 25, width: 50, height: 50)
        
        NSLog("\(rect, fullyRect)", "")
        lockFocus()
        
        //        self.drawInRect(fullyRect)
        
        //        let red = NSColor.redColor()
        //        red.setFill()
        top.drawInRect(rect)
        
        unlockFocus()
        return self
    }
    
    func DrawImageInNSGraphicsContext(size: CGSize, drawFunc: ()->()) -> NSImage {
        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(size.width),
            pixelsHigh: Int(size.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bytesPerRow: 0,
            bitsPerPixel: 0)
        
        let context = NSGraphicsContext(bitmapImageRep: rep!)
        
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(context)
        
        drawFunc()
        
        NSGraphicsContext.restoreGraphicsState()
        
        let image = NSImage(size: size)
        image.addRepresentation(rep!)
        
        return image
    }
    
}

extension NSImage {
    var CGImage: CGImageRef {
        get {
            return self.CGImageForProposedRect(nil, context: nil, hints: nil)!
        }
    }
}


extension GameViewController: SCNSceneRendererDelegate {
    func renderer(renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: NSTimeInterval)  {
    }
    
}

