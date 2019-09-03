//
//  SimultaneousFrontAndBackCameraViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 03/09/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit
import ARKit

class SimultaneousFrontAndBackCameraViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    
    private var mood: Mood?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.userFaceTrackingEnabled = true
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
            
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }
}

extension SimultaneousFrontAndBackCameraViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        if let device = sceneView.device,
            let _ = anchor as? ARFaceAnchor {
            
            let faceGeometry = ARSCNFaceGeometry(device: device)
            let node = SCNNode(geometry: faceGeometry)
            
            node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            
            return node
        }
        
        guard let mood = self.mood else {
            return nil
        }
        
        let emojiNode = EmojiNode(with: [mood.emoji])
        return emojiNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        let happyValue = (faceAnchor.blendShapes[.mouthSmileLeft]?.doubleValue ?? 0.0) + (faceAnchor.blendShapes[.mouthSmileRight]?.doubleValue ?? 0.0)
        let sadValue = (faceAnchor.blendShapes[.mouthFrownLeft]?.doubleValue ?? 0.0) + (faceAnchor.blendShapes[.mouthFrownRight]?.doubleValue ?? 0.0)
        let tongueOutValue = faceAnchor.blendShapes[.tongueOut]?.doubleValue ?? 0.0
        self.mood = Mood(happyValue: happyValue, sadValue: sadValue, tongueOutValue: tongueOutValue)
    }
}
