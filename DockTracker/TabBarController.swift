//
//  TabBarController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 25/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    @IBOutlet var myBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myBar.isTranslucent = false
    }
}
