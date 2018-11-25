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
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
