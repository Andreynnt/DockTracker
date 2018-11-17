//
//  ContainersManager.swift
//  DockTracker
//
//  Created by Андрей Бабков on 17/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

class ContainersManager {
    static var containers: [Container]? {
        didSet {
            gotContainers = true
        }
    }
    static var gotContainers = false
}
