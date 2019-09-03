//
//  FaceTrackingViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 02/09/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit
import ARKit

class FaceTrackingViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    @IBOutlet private weak var unsupportedInfoView: UIView!
    @IBOutlet private weak var `switch`: UISwitch!
    
    private let leftEyeNodeName = "AngryLeftEye"
    private let rightEyeNodeName = "AngryRightEye"
    
    private var faceNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        unsupportedInfoView.isHidden = ARFaceTrackingConfiguration.isSupported
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension FaceTrackingViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        guard let device = sceneView.device else {
            return nil
        }
        
        let faceGeometry = ARSCNFaceGeometry(device: device)
        let node = SCNNode(geometry: faceGeometry)
        self.faceNode = node
        
        node.geometry?.firstMaterial?.fillMode = .lines
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
        
        let rightEye = SCNReferenceNode(named: rightEyeNodeName)
        rightEye.name = rightEyeNodeName
        rightEye.isHidden = true
        node.addChildNode(rightEye)
        
        let leftEye = SCNReferenceNode(named: leftEyeNodeName)
        leftEye.name = leftEyeNodeName
        leftEye.isHidden = true
        node.addChildNode(leftEye)
        
        return node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
            let faceGeometry = node.geometry as? ARSCNFaceGeometry else {
                return
        }
        
        faceGeometry.update(from: faceAnchor.geometry)
        
        DispatchQueue.main.async { [weak self] in
            node.geometry?.firstMaterial?.diffuse.contents = (self?.switch.isOn ?? true) ? UIColor.clear : UIColor.white
        }
        
        if let leftEye = node.childNode(withName: leftEyeNodeName, recursively: true),
            let blink = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float {
            leftEye.simdTransform = faceAnchor.leftEyeTransform
            leftEye.scale.y = 1 - blink
            DispatchQueue.main.async { [weak self] in
                let isOn = self?.switch.isOn ?? true
                leftEye.isHidden = !isOn
            }
        }
        
        if let rightEye = node.childNode(withName: rightEyeNodeName, recursively: true),
            let blink = faceAnchor.blendShapes[.eyeBlinkRight] as? Float {
            rightEye.simdTransform = faceAnchor.rightEyeTransform
            rightEye.scale.y = 1 - blink
            DispatchQueue.main.async { [weak self] in
                let isOn = self?.switch.isOn ?? true
                rightEye.isHidden = !isOn
            }
        }
    }
}
