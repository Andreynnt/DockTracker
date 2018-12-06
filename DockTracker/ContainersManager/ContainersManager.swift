//
//  ContainersManager.swift
//  DockTracker
//
//  Created by Андрей Бабков on 17/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

class ContainersManager {

    var containers = [Container]()

    private static var sharedContainersManager: ContainersManager = {
        let containersManager = ContainersManager()
        return containersManager
    }()

    private init() {

    }

    class func shared() -> ContainersManager {
        return sharedContainersManager
    }

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

    func parseContainers(from json: Any) -> [Container] {
        var tmpContainers = [Container]()
        guard let postsArray = json as? NSArray else {
            print("Parse error")
            return tmpContainers
        }

        for i in postsArray {
            guard let postDict = i as? NSDictionary,
                let container = Container(dict: postDict) else { continue }
            tmpContainers.append(container)
        }
        return tmpContainers
    }
}
