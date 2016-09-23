//
//  ProjectorScene.swift
//  ProjectorPrototype
//
//  Created by Evan Bacon on 9/15/16.
//  Copyright © 2016 Brix. All rights reserved.
//

import Foundation
import Cocoa
import SceneKit
import  SpriteKit
extension CGFloat {
    var inchesToMillimeters:CGFloat {
        return self * 25.4
    }
    var inchesToCentimeters:CGFloat {
        return self * 2.54
    }
    
    var millimetersToCentimeters:CGFloat {
        return self / 10
    }
    var millimetersToInches:CGFloat {
        return self / 25.4
    }
}

func * (lhs:SCNVector3, rhs:SCNVector3) -> SCNVector3 {
    return SCNVector3(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
}

class ProjectorScene: SCNScene {
    var texture: SKScene!
    let res: CGFloat = 1024
    var mesh:SCNNode!
    var millimeters:SCNVector3 = SCNVector3()
    var generativeParticle: SKEmitterNode!

    //W, H, D - inches
    var meshSize = SCNVector3(x: 6,y: 6,z: 6)
    override init() {
        super.init()
        
        setupLights()
        
        setupTexture()
        
        setupMesh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProjectorScene {
    func setupTexture() {
        texture = VelocityScene(size: CGSize(width: res, height: res))
        texture.scaleMode = .aspectFit
    }
    
    func setupGameView(scene:SCNScene, camera:SCNNode) -> GameView {
        let gameView = GameView(frame: CGRect(origin: CGPoint(), size: CGSize(width: 100, height: 100)))
        gameView.translatesAutoresizingMaskIntoConstraints = false
        // set the scene to the view
        gameView.scene = scene
        
        
        // allows the user to manipulate the camera
        gameView.allowsCameraControl = DEBUG
        
        // show statistics such as fps and timing information
        gameView.showsStatistics = DEBUG
        
        // configure the view
        gameView.backgroundColor = NSColor.gray
        
        //        gameView.debugOptions = SCNDebugOptions.ShowBoundingBoxes
        gameView.isPlaying = true
        
        gameView.overlaySKScene = CursorScene(size: gameView.frame.size)
        gameView.overlaySKScene!.isHidden = false
        gameView.overlaySKScene!.scaleMode = .aspectFill
        
        
        //        gameView.autoenablesDefaultLighting = true
        
        scene.rootNode.addChildNode(camera)
        gameView.pointOfView = camera
        
        return gameView
    }
    
    func addView( scene:SCNScene, angle:Double) -> GameView {
        
        // create and add a camera to the scene
        let camera = setupCamera(scene)
        
        //        let meshSize = mesh.size()
        camera.rotation = SCNVector4(0, 1, 0, angle + M_PI)
        
        let y = camera.position.y
        camera.position = getMoveVectorForAngle(angle, distance: Double(camera.position.z))
        camera.position.y = y
        
        print("camera", camera.position * meshSize,camera.position, angle, camera.rotation)
        let sceneView = setupGameView(scene: scene, camera: camera)
        
        return sceneView
    }
    
    fileprivate func setupCamera(_ scene:SCNScene) -> SCNNode {
        let min = mesh.min()
        let size = mesh.size()
        let center = mesh.center
        let largestSide = Double(max(size.x, max(size.y, size.z))) * 1.1
        
        let cameraNode = SCNNode()
        cameraNode.name = "camera"
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: center.x, y: center.y , z: min.z + CGFloat(largestSide))
        cameraNode.camera?.usesOrthographicProjection = true
        cameraNode.camera?.zNear = 0.0001
        
        cameraNode.camera?.zFar = (largestSide + 5) * 100 //Dont even think about it
        //        cameraNode.camera?.xFov = largestSide
        //        cameraNode.camera?.automaticallyAdjustsZRange = true
        cameraNode.camera?.orthographicScale = largestSide / 2
        //        let lookAt = SCNLookAtConstraint(target:mesh)
        ////        lookAt.gimbalLockEnabled = true
        //        cameraNode.constraints = [lookAt]
        return cameraNode
    }
    
    fileprivate func setupLights() {
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight().defaultOmni()
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight().defaultAmbient()
        rootNode.addChildNode(ambientLightNode)
    }
    
    func setupMesh(_ name:String="Cube") {
        mesh = buildMesh(named: name)
        mesh.geometry?.firstMaterial?.diffuse.contents = texture
        //        self.mesh.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 3)))
        
        rootNode.addChildNode(mesh)
        mesh.resetTransforms()
        
        //        mesh.centerPivot()
    }
    
    fileprivate func buildMesh(named:String?=nil) -> SCNNode {
        var mesh:SCNNode?
        
        if let name = named {
            if let node = rootNode.childNode(withName: name, recursively: true) {
                mesh = node
            } else {
                if name == "cube" {
                    mesh = SCNNode(geometry: SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0))
                    
                } else if name == "sphere" {
                    mesh = SCNNode(geometry: SCNSphere(radius: 1))
                    
                }
                /// Dope debuging
                let names = rootNode.childNodes.map({
                    node in
                    node.name
                })
                print("Wrong mesh name, maybe you meant: \(names)")
            }
        } else {
            //            mesh = SCNNode(geometry: SCNBox(width: 2,height: 2,length: 2,chamferRadius: 0))
            
            mesh = SCNNode(geometry: SCNSphere(radius: 1))
        }
        
        return mesh ?? buildMesh()
    }
    
}

extension ProjectorScene {
    fileprivate func getMoveVectorForAngle(_ angle: Double = 0, distance: Double = 15) -> SCNVector3 {
        return getSphericalCoords(0, tVal: angle, rVal: distance)
    }
    
    func getSphericalCoords(_ sVal: Double, tVal: Double, rVal: Double) -> SCNVector3 {
        return SCNVector3(-(cos(sVal) * sin(tVal) * rVal),
                          sin(sVal) * rVal,
                          -(cos(sVal) * cos(tVal) * rVal))
    }
}


extension ProjectorScene {
    func setupParticle() {
        let path = Bundle.main.path(forResource: "Paint", ofType: "sks")
        
        if let generativeParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as? SKEmitterNode {
            
            self.generativeParticle = generativeParticle
            generativeParticle.position = CGPoint(x: texture.size.width/2, y: texture.size.height/2)
            generativeParticle.name = "rainParticle"
            generativeParticle.targetNode = texture
            
            texture.addChild(generativeParticle)
        }
    }
    func generator() -> SKEmitterNode {
        return self.generativeParticle.copy() as! SKEmitterNode
    }
    
}
