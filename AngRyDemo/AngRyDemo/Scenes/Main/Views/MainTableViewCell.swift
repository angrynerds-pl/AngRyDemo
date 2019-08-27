//
//  MainTableViewCell.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 27/08/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        titleLabel.text = ""
    }
    
    func setup(for scene: Scene) {
        titleLabel.text = scene.title
    }
}
