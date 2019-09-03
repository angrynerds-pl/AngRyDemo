//
//  SCNReferenceNode.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 03/09/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import SceneKit.SCNReferenceNode

extension SCNReferenceNode {
    convenience init(named resourceName: String) {
        let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "art.scnassets")!
        self.init(url: url)!
        self.load()
    }
}

