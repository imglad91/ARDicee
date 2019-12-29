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
