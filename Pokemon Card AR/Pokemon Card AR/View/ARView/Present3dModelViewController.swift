//
//  ViewController.swift
//  Pokemon Card AR
//
//  Created by Victor S Melo on 02/11/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class Present3dModelViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var pokemon3dAssetName: String!
    var alreadyAddedModel = false
    
    var planes = [UUID:Plane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        
//        self.sceneView.debugOptions = SCNDebugOptions(rawValue: ARSCNDebugOptions.showWorldOrigin.rawValue | ARSCNDebugOptions.showFeaturePoints.rawValue)
//        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
        let anchor = ARAnchor(name: pokemon3dAssetName, transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
    }
    
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if alreadyAddedModel {
            return
        }
        
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let plane = Plane(anchor: planeAnchor)
            self.planes[anchor.identifier] = plane
            node.addChildNode(plane)
            
        } else if anchor.name == pokemon3dAssetName! {
            let sceneURL = Bundle.main.url(forResource: pokemon3dAssetName!, withExtension: "scn", subdirectory: "art.scnassets")!
            let referenceNode = SCNReferenceNode(url: sceneURL)!
            referenceNode.load()
            node.addChildNode(referenceNode)
            alreadyAddedModel = true
            
            self.planes.values.forEach {
                $0.isHidden = true
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        guard let planeAnchor = anchor as? ARPlaneAnchor, let plane = self.planes[anchor.identifier] else {
            return
        }
    
        plane.update(planeAnchor)
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
