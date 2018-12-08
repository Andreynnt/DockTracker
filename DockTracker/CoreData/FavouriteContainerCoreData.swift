//
//  FavouriteContainerCoreData.swift
//  DockTracker
//
//  Created by Андрей Бабков on 08/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation
import CoreData

extension FavouriteContainerCoreData {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "FavouriteContainerCoreData"), insertInto: CoreDataManager.instance.managedObjectContext)
    }
}
