//
//  LightEstimationViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 28/08/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit
import ARKit

class LightEstimationViewController: UIViewController {

    @IBOutlet private weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let scene = SCNScene(named: "art.scnassets/AngryHead.scn") else {
            return
        }
        sceneView.scene = scene
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
}

extension LightEstimationViewController: ARSCNViewDelegate {  }
