//
//  PreloaderViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 26/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class PreloaderViewController: UIViewController {
    let segueName = "openApp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillContainersManager()
    }
    
    func fillContainersManager() {
        let manager = ContainersManager.shared()
        manager.getContainers(mainCallback: {() -> Void in
            self.performSegue(withIdentifier: self.segueName, sender: self)
        })
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let containersView = segue.destination as! ContainersViewController
//        containersView.containers = containers
//    }
    
}
