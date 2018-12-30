//
//  ServerService.swift
//  DockTracker
//
//  Created by Андрей Бабков on 30/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

class ServerService {
    var preferredServer: ServerCoreData?
    var preferredServerIsConnected = false
    var servers: [ServerCoreData]?

    
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "ServerCoreData", keyForSort: "server")
    
    private static var service: ServerService = {
        let service = ServerService()
        //получаем fav
        service.servers = service.fetchServers()
        return service
    }()
    
    class func shared() -> ServerService {
        return service
    }
    
    private init() {
    
    }
    
    func fetchServers() -> [ServerCoreData]? {
        do {
            try self.fetchedResultsController.performFetch()
            let servers = self.fetchedResultsController.fetchedObjects as? [ServerCoreData]
            if let parsedServers = servers {
                for server in parsedServers {
                    if server.selected {
                        preferredServer = server
                        break
                    }
                }
                return servers
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func getStatus(server: ServerCoreData, callback: ((Bool, String) -> Void)? = nil) {
        let url = getUrl(server: server)
        guard let urlParsed = URL(string: url + "/containers/json") else { return }
        URLSession.shared.dataTask(with: urlParsed) { (_, response, error) in
            if let error = error {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    callback?(false, "Not available")
                }
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async {
                        callback?(true, "Connected")
                    }
                    return
                }
            }
            DispatchQueue.main.async {
                callback?(false, "Docker connection refused")
            }
        }.resume()
        
    }
    
    func getUrl(server: ServerCoreData) -> String {
        let webProtocol = server.webProtocol!
        let domain = server.server!
        let port = server.port
        return "\(webProtocol)://\(domain):\(port)"
    }
}
