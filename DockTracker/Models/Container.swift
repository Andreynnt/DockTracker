//
//  Container.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

struct Container {
    var image = ""
    var state = ""
    var names = [String]()
    var firstName = ""
    var id = ""
    var status = ""
    var command = ""
    
    func isStarted() -> Bool {
        return state == "running"
    }
}

extension Container {
    init?(dict: NSDictionary) {
        if let image = dict["Image"] as? String {
            self.image = image
        }
        
        if let names = dict["Names"] as? [String] {
            self.names = names
            if var firstName = names.first {
                firstName.remove(at: firstName.startIndex)
                self.firstName = firstName
            }
        }
        
        if let state = dict["State"] as? String {
            self.state = state
        }
        if let id = dict["Id"] as? String {
            self.id = id
        }
        if let status = dict["Status"] as? String {
            self.status = status
        }
        if let command = dict["Command"] as? String {
            self.command = command
        }
    }
}
