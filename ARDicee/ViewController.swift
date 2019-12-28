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
 
 //MARK: - Create a Cube
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cube.materials = [material]
        
//MARK: - Create a Sun
        let sphere = SCNSphere(radius: 0.3)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "art.scnassets/sun.jpg")
        sphere.materials = [sphereMaterial]

//MARK: - Creating a node and adding the shape to the node
        let node = SCNNode()
        node.position = SCNVector3(0, 0.1, -1)
        node.geometry = sphere

//MARK: - Displaying the node
        sceneView.scene.rootNode.addChildNode(node)
        sceneView.autoenablesDefaultLighting = true
        

        
        
        
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
//        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }


}
