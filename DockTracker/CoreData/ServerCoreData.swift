//
//  ServerCoreData.swift
//  DockTracker
//
//  Created by Андрей Бабков on 28/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation
import CoreData

extension ServerCoreData {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "ServerCoreData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
