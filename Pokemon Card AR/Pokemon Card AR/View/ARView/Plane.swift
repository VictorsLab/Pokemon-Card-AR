//
//  Plane.swift
//  Pokemon Card AR
//
//  Created by Victor S Melo on 03/11/18.
//  Copyright © 2018 Victor Melo. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class Plane: SCNNode {
    var anchor: ARPlaneAnchor
    var planeGeometry: SCNPlane
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        self.planeGeometry = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.y))
        
        let material = SCNMaterial()
        let grid = UIImage(named: "floor_grid")
        material.diffuse.contents = grid
        self.planeGeometry.materials = [material]

        let planeNode = SCNNode(geometry: self.planeGeometry)
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        
        // Planes in SceneKit are vertical by default so we need to rotate 90degrees to match
        // planes in ARKit
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1.0, 0.0, 0.0)
        
        super.init()
        
        self.setTextureScale()
        self.addChildNode(planeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ anchor: ARPlaneAnchor) {
        
        // As the user moves around the extend and location of the plane
        // may be updated. We need to update our 3D geometry to match the
        // new parameters of the plane.
        self.planeGeometry.width = CGFloat(anchor.extent.x)
        self.planeGeometry.height = CGFloat(anchor.extent.z)
        
        // When the plane is first created it's center is 0,0,0 and the nodes
        // transform contains the translation parameters. As the plane is updated
        // the planes translation remains the same but it's center is updated so
        // we need to update the 3D geometry position
        self.position = SCNVector3Make(anchor.center.x, 0, anchor.center.z)
        self.setTextureScale()
    }
    
    private func setTextureScale() {
        
        let width = self.planeGeometry.width
        let height = self.planeGeometry.height
    
        // As the width/height of the plane updates, we want our grid material to
        // cover the entire plane, repeating the texture over and over. Also if the
        // grid is less than 1 unit, we don't want to squash the texture to fit, so
        // scaling updates the texture co-ordinates to crop the texture in that case
        guard let material = self.planeGeometry.materials.first else {
            return
        }

        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material.diffuse.wrapS = SCNWrapMode.repeat
        material.diffuse.wrapT = SCNWrapMode.repeat
    }
    
    
}

