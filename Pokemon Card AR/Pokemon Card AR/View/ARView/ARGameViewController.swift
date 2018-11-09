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

class ARGameViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var pokemon3dAssetName: String!
    let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "Cards", bundle: Bundle.main)
    
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
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages!
        configuration.maximumNumberOfTrackedImages = 6

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor, let pokemon3dAssetName =
            imageAnchor.referenceImage.name {

            
            let sceneURL = Bundle.main.url(forResource: pokemon3dAssetName, withExtension: "scn", subdirectory: "art.scnassets")!
            let referenceNode = SCNReferenceNode(url: sceneURL)!
            referenceNode.load()
            referenceNode.scale = SCNVector3(x: 0.2, y: 0.2, z: 0.2)
            node.addChildNode(referenceNode)
            
//            self.planes.values.forEach {
//                $0.isHidden = true
//            }
            
//            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
//            plane.firstMaterial?.diffuse.contents = UIColor.blue
//
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.eulerAngles.x = -.pi / 2
//
//            node.addChildNode(planeNode)
        }
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        if let planeAnchor = anchor as? ARPlaneAnchor {
//            let plane = Plane(anchor: planeAnchor)
//            self.planes[anchor.identifier] = plane
//            node.addChildNode(plane)
//
//        } else if anchor.name == pokemon3dAssetName! {
//            let sceneURL = Bundle.main.url(forResource: pokemon3dAssetName!, withExtension: "scn", subdirectory: "art.scnassets")!
//            let referenceNode = SCNReferenceNode(url: sceneURL)!
//            referenceNode.load()
//            node.addChildNode(referenceNode)
//            alreadyAddedModel = true
//
//            self.planes.values.forEach {
//                $0.isHidden = true
//            }
//        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
//        guard let planeAnchor = anchor as? ARPlaneAnchor, let plane = self.planes[anchor.identifier] else {
//            return
//        }
//
//        plane.update(planeAnchor)
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
