//
//  Container.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

struct Container {

    var image = СontainerParameter(name: "Image", value: "")
    var state = СontainerParameter(name: "State", value: "")
    var names = [String]()
    var id = СontainerParameter(name: "Id", value: "")
    var name = СontainerParameter(name: "Name", value: "")
    var status = СontainerParameter(name: "Status", value: "")
    var command = СontainerParameter(name: "Command", value: "")
    var imageId = СontainerParameter(name: "Image id", value: "")
    var isFavourite = false
    
    var parametersArray = [СontainerParameter]()

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

    func getParametersArray() -> [СontainerParameter] {
        return parametersArray
    }
}

extension Container {
    init?(dict: NSDictionary) {
        if let image = dict["Image"] as? String {
            self.image.value = image
            self.image.setup()
        }

        if let names = dict["Names"] as? [String] {
            self.names = names
            if var name = names.first {
                name.remove(at: name.startIndex)
                self.name.value = name
                self.name.setup()
            }
        }
        if let state = dict["State"] as? String {
            self.state.value = state
            self.state.setup()
        }
        if let id = dict["Id"] as? String {
            self.id.value = id
            self.id.setup()
        }
        if let imageId = dict["ImageID"] as? String {
            self.imageId.value = imageId
            self.imageId.setup()
        }

        if let status = dict["Status"] as? String {
            self.status.value = status
            self.status.setup()
        }
        if let command = dict["Command"] as? String {
            self.command.value = command
            self.command.setup()
        }
        setParametersArray()
    }

}
