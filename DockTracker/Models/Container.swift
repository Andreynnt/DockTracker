//
//  Container.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

struct Container {
    
    var image = (name: "Image", value: "")
    var state = (name: "State", value: "")
    var names = [String]()
    var name = (name: "Name", value: "")
    var id = (name: "Id", value: "")
    var status = (name: "Status", value: "")
    var command = (name: "Command", value: "")
    var imageId = (name: "Image id", value: "")
    
    var parametersArray = [(name: String, value: String)]()
    
    func isStarted() -> Bool {
        return state.value == "running"
    }
    
    mutating func setParametersArray() {
        if  !image.value.isEmpty {
            parametersArray.append(image)
        }
        if  !state.value.isEmpty {
            parametersArray.append(state)
        }
        if  !name.value.isEmpty {
            parametersArray.append(name)
        }
        if  !status.value.isEmpty {
            parametersArray.append(status)
        }
        if  !id.value.isEmpty {
            parametersArray.append(id)
        }
        if  !command.value.isEmpty {
            parametersArray.append(command)
        }
        if  !imageId.value.isEmpty {
            parametersArray.append(imageId)
        }
    }
    
    func getParametersArray() -> [(name: String, value: String)] {
        return parametersArray
    }
}

extension Container {
    init?(dict: NSDictionary) {
        if let image = dict["Image"] as? String {
            self.image.value = image
        }
        
        if let names = dict["Names"] as? [String] {
            self.names = names
            if var name = names.first {
                name.remove(at: name.startIndex)
                self.name.value = name
            }
        }
        if let state = dict["State"] as? String {
            self.state.value = state
        }
        if let id = dict["Id"] as? String {
            self.id.value = id
        }
        if let imageId = dict["ImageID"] as? String {
            self.imageId.value = imageId
        }
        
        if let status = dict["Status"] as? String {
            self.status.value = status
        }
        if let command = dict["Command"] as? String {
            self.command.value = command
        }
        setParametersArray()
    }
    
}
