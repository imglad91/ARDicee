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
        
        sceneView.delegate = self
        
     
        sceneView.autoenablesDefaultLighting = true
        sceneView.showsStatistics = true
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
    
    //MARK: - Dice Rendering Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {
             addDice(atLocation: hitResult)
                }
            
            }

        }
    
    func addDice(atLocation location:ARHitTestResult) {
       
                let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
        
                if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
                diceNode.position = SCNVector3(
                    location.worldTransform.columns.3.x,
                    location.worldTransform.columns.3.y + diceNode.boundingSphere.radius,
                    location.worldTransform.columns.3.z)
                    
                diceArray.append(diceNode)
                    
                sceneView.scene.rootNode.addChildNode(diceNode)
                   
                    roll(dice: diceNode)
              
                
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
    
    //MARK: - ARSCNViewDelegateMethods
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

    guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
        
        let planeNode = createPlane(withPlaneAnchor: planeAnchor)

        node.addChildNode(planeNode)
        

    }

    //MARK: - Plane Rendering Methods
    func createPlane(withPlaneAnchor planeAnchor: ARPlaneAnchor)->SCNNode {
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode()
        planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)

        let gridMaterial = SCNMaterial()
        gridMaterial.diffuse.contents = UIImage(named:"art.scnassets/grid.png")

        plane.materials = [gridMaterial]
        planeNode.geometry = plane
        return planeNode
    }
}



