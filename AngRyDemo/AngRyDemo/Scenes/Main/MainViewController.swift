//
//  MainViewController.swift
//  AngRyDemo
//
//  Created by Lukasz Lech on 27/08/2019.
//  Copyright © 2019 Angry Nerds. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let scene = Scene(rawValue: indexPath.row),
            let storyboardName = scene.storyboardName,
            let viewControllerIdentifier = scene.viewControllerIdentifier else {
                return
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier)
        viewController.title = scene.title
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Scene.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell,
            let scene = Scene(rawValue: indexPath.row) else {
                return UITableViewCell()
        }
        
        cell.setup(for: scene)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / CGFloat(Scene.allCases.count)
    }
}
