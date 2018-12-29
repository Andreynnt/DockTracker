//
//  ContainersManager.swift
//  DockTracker
//
//  Created by Андрей Бабков on 17/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation
import CoreData

class ContainersManager {

    //to do. Сейчас используется только для Stacks View
    var containers = [Container]()
    
    var stoppedContainers = [Container]()
    var workingContainers = [Container]()

    //favourite
    var favouriteContainers = [Container]()
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "FavouriteContainerCoreData", keyForSort: "id")
    var favouriteContainersMap = [String: Bool]()
    
    private static var sharedContainersManager: ContainersManager = {
        let containersManager = ContainersManager()
        return containersManager
    }()
    
    //singleton
    class func shared() -> ContainersManager {
        return sharedContainersManager
    }

    private init() { }
    
    func getContainers(mainCallback: (() -> Void)? = nil, callback: ((_ containers: [Container]) -> Void)? = nil) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/json?all=1"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                do {
                    //избранные контейнеры берем из бд
                    try self.fetchedResultsController.performFetch()
                    let coreDataContainers = self.fetchedResultsController.fetchedObjects as! [FavouriteContainerCoreData]
                    self.fillFavouriteMap(coreDataContainers: coreDataContainers)
                } catch {
                    print("fetchedResultsController.performFetch() error")
                }
                self.containers = self.parseContainers(from: json)
                callback?(self.containers)
                
                if mainCallback != nil {
                    DispatchQueue.main.async {
                        mainCallback!()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    //добавляем в хэш мапку избранные контейнеры, чтобы потом в методе parseContainers()
    //было быстро О(1) проверять есть ли контейнер в избранных
    func fillFavouriteMap(coreDataContainers: [FavouriteContainerCoreData]) {
        for container in coreDataContainers {
            if let id  = container.id {
                favouriteContainersMap[id] = true
            }
        }
    }

    func parseContainers(from json: Any) -> [Container] {
        var tmpContainers = [Container]()
        guard let postsArray = json as? NSArray else {
            print("Parse error")
            return tmpContainers
        }

        for i in postsArray {
            guard let postDict = i as? NSDictionary,
                var container = Container(dict: postDict) else { continue }
            tmpContainers.append(container)
            
            if favouriteContainersMap[container.id.value] != nil {
                container.isFavourite = true
                favouriteContainers.append(container)
            }
            
            if container.isStarted() {
                workingContainers.append(container)
            } else {
                stoppedContainers.append(container)
            }
        }
        return tmpContainers
    }
    
    func deleteFromFavourites(container: Container, section: ContainersSection?, num: Int) {
        let predicate = NSPredicate(format: "id = %@", container.id.value)
        fetchedResultsController.fetchRequest.predicate = predicate
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("fetchedResultsController.performFetch() error")
        }
        if let objects = self.fetchedResultsController.fetchedObjects {
            if !objects.isEmpty {
                let objectToDelete = objects[0] as! FavouriteContainerCoreData
                CoreDataManager.instance.managedObjectContext.delete(objectToDelete)
                CoreDataManager.instance.saveContext()
            }
        }
        //удаление из массива favouriteContainers[]
        for (index, favContainer) in favouriteContainers.enumerated() where favContainer.id.value == container.id.value {
            favouriteContainers.remove(at: index)
        }
        //удаление из хеш-мапы favouriteContainersMap
        if favouriteContainersMap[container.id.value] != nil {
            favouriteContainersMap.removeValue(forKey: container.id.value)
        }
        changeIsFavouriteInSection(section: section, at: num, to: false)
    }
    
    func addToFavourite(container: Container, section: ContainersSection?, num: Int) {
        let managedObject = FavouriteContainerCoreData()
        managedObject.id = container.id.value
        CoreDataManager.instance.saveContext()

        changeIsFavouriteInSection(section: section, at: num, to: true)
        favouriteContainersMap[container.id.value] = true
        favouriteContainers.append(container)
    }
    
    //меняем значение isFavourite в stoppedContainers[] либо workingContainers[]
    //необходимо сделать, тк эти массивы потом передаются из MainMenu в ContainersViewController
    func changeIsFavouriteInSection(section: ContainersSection?, at num: Int, to value: Bool) {
        if let section = section {
            switch section {
            case .Stopped:
                self.stoppedContainers[num].isFavourite = value
            case .Working:
                self.workingContainers[num].isFavourite = value
            case .Favourite:
                return
            }
        }
    }
    
    func deleteCommonContainerFromArray(at position: Int, section: ContainersSection?) {
        if let section = section {
            switch section {
            case .Stopped:
                stoppedContainers.remove(at: position)
            case .Working:
                workingContainers.remove(at: position)
            case .Favourite:
                return
            }
        }
    }
    
    func addCommonContainerToArray(container: Container, section: ContainersSection?) {
        if let section = section {
            switch section {
            case .Stopped:
                stoppedContainers.append(container)
            case .Working:
                workingContainers.append(container)
            case .Favourite:
                return
            }
        }
    }
}
