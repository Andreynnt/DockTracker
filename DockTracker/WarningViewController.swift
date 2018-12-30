//
//  WarningViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 30/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class WarningViewController: UIViewController {

    let segue = "warningToSettings"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("WarningViewController viewDidLoad")
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        performSegue(withIdentifier: segue, sender: self)
    }
}
