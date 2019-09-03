//
//  ImageRecognitionViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 03/09/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit
import ARKit
import SafariServices

class ImageRecognitionViewController: UIViewController {
    
    @IBOutlet private weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    func setupConfiguration() {
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else { return }
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = referenceImages
        let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
        sceneView.session.run(configuration, options: options)
    }
    
    func navigateToWebPage() {
        let urlString = "https://www.angrynerds.pl"
        
        if let url = URL(string: urlString) {
            let viewController = SFSafariViewController(url: url)
            viewController.delegate = self
            
            DispatchQueue.main.async { [weak self] in
                let navigationController = UINavigationController(rootViewController: viewController)
                self?.navigationController?.present(navigationController, animated: true, completion: nil)
            }
        }
    }
}

extension ImageRecognitionViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARImageAnchor else { return }
        navigateToWebPage()
    }
}

extension ImageRecognitionViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        setupConfiguration()
    }
}
