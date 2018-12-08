//
//  ContainersManager.swift
//  DockTracker
//
//  Created by Андрей Бабков on 17/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

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
                    try self.fetchedResultsController.performFetch()
                    let coreDataContainers = self.fetchedResultsController.fetchedObjects as! [FavouriteContainerCoreData]
                    self.fillFavouriteMap(coreDataContainers: coreDataContainers)
                } catch {
                    print(error)
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
    
    //добавляем в хэш мапку избранные контейнеры, чтобы потом было быстро О(1) проверять
    //есть ли контейнер в избранных
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
    
            if container.isStarted() {
                workingContainers.append(container)
            } else {
                stoppedContainers.append(container)
            }
            
            if favouriteContainersMap[container.id.value] != nil {
                container.isFavourite = true
                favouriteContainers.append(container)
            }
        }
        return tmpContainers
    }
    
    func deleteFromFavourite(container: Container) {
        for (index, favContainer) in favouriteContainers.enumerated() where favContainer.id.value == container.id.value {
                favouriteContainers.remove(at: index)
                return
        }
        if favouriteContainersMap[container.id.value] != nil {
            favouriteContainersMap.removeValue(forKey: container.id.value)
        }
    }
    
    func addToFavourite(container: Container) {
        favouriteContainersMap[container.id.value] = true
        favouriteContainers.append(container)
    }

}
