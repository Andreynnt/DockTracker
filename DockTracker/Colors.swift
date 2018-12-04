//
//  Colors.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    //default
    let black = UIColor.black

    //other
    let purple = UIColor(red:0.48, green:0.51, blue:0.97, alpha:1.0)
    let white = UIColor.white
    
    private static var colors: Colors  = {
        let colors = Colors()
        return colors
    }()
    
    private init() {
        
    }
    
    class func shared() -> Colors {
        return colors
    }
}
