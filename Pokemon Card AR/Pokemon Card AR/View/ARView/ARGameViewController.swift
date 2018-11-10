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
        let scene = SCNScene()
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
        }
        return node
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        session.getCurrentWorldMap { (worldMap, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let worldMap = worldMap else {
                print("[ARGameViewController] Error: Could not find a world map")
                return
            }
            worldMap.anchors.removeAll()
        }
        
    }
}
