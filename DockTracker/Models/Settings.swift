//
//  Settings.swift
//  DockTracker
//
//  Created by Андрей Бабков on 06/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

struct Settings: Codable {
    let (nameKey, addressKey) = ("name", "address")
    let userSessionKey = "com.save.usersession"
    let urls = [(domain: String, port: Int)]()

//    var name: String?
//    var address: String?
//
//    init(_ json: [String: String]) {
//        self.name = json[nameKey]
//        self.address = json[addressKey]
//    }


}
