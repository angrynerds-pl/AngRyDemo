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
    case imageRecognition = 1
    case faceTracking = 2
    case collaborativeSessions = 3
    case simultaneous = 4
    case motionCapture = 5
    
    var title: String {
        switch self {
            case .planeDetection: return "Plane Detection"
            case .imageRecognition: return "Image Recognition"
            case .faceTracking: return "Face Tracking"
            case .collaborativeSessions: return "Collaborative Sessions with People Occlusion"
            case .simultaneous: return "Simultaneous Front and Back Camera"
            case .motionCapture: return "Motion Capture"
        }
    }
    
    var storyboardName: String? {
        switch self {
            case .planeDetection: return "PlaneDetection"
            case .imageRecognition: return "ImageRecognition"
            case .faceTracking: return "FaceTracking"
            case .collaborativeSessions: return "CollaborativeSessions"
            case .simultaneous: return "SimultaneousFrontAndBackCamera"
            case .motionCapture: return nil
        }
    }
    
    var viewControllerIdentifier: String? {
        return storyboardName
    }
}
