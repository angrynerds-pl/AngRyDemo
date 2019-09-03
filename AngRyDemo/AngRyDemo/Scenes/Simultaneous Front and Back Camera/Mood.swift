//
//  Mood.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 04/09/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import Foundation

enum Mood {
    case happy
    case sad
    case togueOut
    
    init(happyValue: Double, sadValue: Double, tongueOutValue: Double) {
        if tongueOutValue > 0.75 {
            self = .togueOut
        } else {
            self = happyValue > sadValue ? .happy : .sad
        }
    }
    
    var emoji: String {
        switch self {
            case .happy: return "😀"
            case .sad: return "☹️"
            case .togueOut: return "😛"
        }
    }
}
