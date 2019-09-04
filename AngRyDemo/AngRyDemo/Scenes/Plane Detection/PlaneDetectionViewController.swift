//
//  PlaneDetectionViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 28/08/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit
import ARKit

class PlaneDetectionViewController: UIViewController {

    @IBOutlet private weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.2
            let transform = simd_mul(currentFrame.camera.transform, translation)
            
            let node = spawnBall()
            node.simdTransform = transform
            sceneView.scene.rootNode.addChildNode(node)
        }
    }
    
    func spawnBall() -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        let physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        physicsBody.categoryBitMask = 2
        physicsBody.collisionBitMask = 1 + 2
        let ball = SCNNode(geometry: sphere)
        ball.physicsBody = physicsBody
        return ball
    }
}

extension PlaneDetectionViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        
        plane.firstMaterial?.diffuse.contents = UIImage(named: "logo-grid")
        plane.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
        plane.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
        plane.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(32, 32, 0)
        
        let planeNode = SCNNode(geometry: plane)
        
        let physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        physicsBody.categoryBitMask = 1
        physicsBody.collisionBitMask = 2
        planeNode.physicsBody = physicsBody
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else {
                return
        }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
}
