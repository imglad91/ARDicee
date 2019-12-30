//
//  ViewController.swift
//  ARDicee
//
//  Created by Glad Poenaru on 2019-12-28.
//  Copyright © 2019 Glad Poenaru. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    var diceArray = [SCNNode]()

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the view's delegate
        sceneView.delegate = self
        
       self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
//
// //MARK: - Create a Cube
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.red
//        cube.materials = [material]
//
////MARK: - Create a Sun
//        let sphere = SCNSphere(radius: 0.3)
//        let sphereMaterial = SCNMaterial()
//        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
//        sphere.materials = [sphereMaterial]
//
////MARK: - Creating a node and adding the shape to the node
//        let node = SCNNode()
//        node.position = SCNVector3(0, 0.1, -1)
//        node.geometry = sphere
//
////MARK: - Displaying the node
//        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        

        
        
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
//
//        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//        diceNode.position = SCNVector3(0, 0, -0.1)
//        sceneView.scene.rootNode.addChildNode(diceNode)
//
//      }
   }
     
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        //Plane detection
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                diceNode.position = SCNVector3(
                    hitResult.worldTransform.columns.3.x,
                    hitResult.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                    hitResult.worldTransform.columns.3.z)
                    
                diceArray.append(diceNode)
                    
                sceneView.scene.rootNode.addChildNode(diceNode)
                   
                    roll(dice: diceNode)
                    
                }
            
            
            
//            if !results.isEmpty {
//                print("Touched the plane")
//            } else { print("Tocuhed somewhere else")}
        }
    }
}
    
    
    
    func rollAll() {
        if !diceArray.isEmpty {
            for dice in diceArray {
            roll(dice: dice) }
        }
    }
    
    func roll(dice: SCNNode) {
        let randomX = Float(arc4random_uniform(4)+1) * Float.pi/2
        let randomY = Float(arc4random_uniform(4)+1) * Float.pi/2
        let randomZ = Float(arc4random_uniform(4)+1) * Float.pi/2
        
        dice.runAction(SCNAction.rotateBy(x: CGFloat(randomX)*10, y: CGFloat(randomY*10), z: CGFloat(randomZ)*10, duration: 2))

}
    @IBAction func rollDice(_ sender: UIBarButtonItem) {
        rollAll()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        rollAll()
    }
    
    @IBAction func deleteAllDice(_ sender: UIBarButtonItem) {
        
        if !diceArray.isEmpty {
          for dice in diceArray {
          dice.removeFromParentNode()
          }
        }
    
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor {
            print("Plane detected")
            let planeAchor = anchor as! ARPlaneAnchor
            let plane = SCNPlane(width: CGFloat(planeAchor.extent.x), height: CGFloat(planeAchor.extent.z))
            let planeNode = SCNNode()
            planeNode.position = SCNVector3(x: planeAchor.center.x, y: 0, z: planeAchor.center.z)
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named:"art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else { return }
    }

    
}
