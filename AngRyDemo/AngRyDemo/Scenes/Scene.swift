//
//  Scene.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 27/08/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import Foundation

enum Scene: Int, CaseIterable {
    case planeDetection = 0
    case lightEstimation = 1
    case imageRecognition = 2
    case faceTracking = 3
    case collaborativeSessions = 4
    case simultaneous = 5
    case peopleOcclusion = 6
    case motionCapture = 7
    
    var title: String {
        switch self {
            case .planeDetection: return "Plane Detection"
            case .lightEstimation: return "Light Estimation"
            case .imageRecognition: return "Image Recognition"
            case .faceTracking: return "Face Tracking"
            case .collaborativeSessions: return "Collaborative Sessions"
            case .simultaneous: return "Simultaneous Front and Back Camera"
            case .peopleOcclusion: return "People Occlusion"
            case .motionCapture: return "Motion Capture"
        }
    }
    
    var storyboardName: String? {
        switch self {
            case .planeDetection: return "PlaneDetection"
            case .lightEstimation: return "LightEstimation"
            case .imageRecognition: return nil
            case .faceTracking: return nil
            case .collaborativeSessions: return nil
            case .simultaneous: return nil
            case .peopleOcclusion: return nil
            case .motionCapture: return nil
        }
    }
    
    var viewControllerIdentifier: String? {
        return storyboardName
    }
}
