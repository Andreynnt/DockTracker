//
//  File.swift
//  DockTracker
//
//  Created by Андрей Бабков on 24/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

struct СontainerParameter {
    var name: String = ""
    var value: String = ""

    var maxLineLength = 33
    var shortHeight = 70
    var fullHeight = 70
    var isCompact = true
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    // функция для того, чтобы знать размер строчек в развернутом виде
    mutating func setup() {
        var lines = value.count / maxLineLength
        if value.count % maxLineLength != 0 {
            lines += 1
        }
        let deltaHeight = 17 * (lines - 1)
        self.fullHeight += deltaHeight
    }
}
