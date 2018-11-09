//
//  UserSettings.swift
//  DockTracker
//
//  Created by Андрей Бабков on 03/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation


class UserSettings {
    struct Settings {
        
    }
    
    static func saveUrl(domain: String, port: Int = 80) {
        let parsedDomain = parseDomain(domain)
        if var arrayOfUrls = UserDefaults.standard.array(forKey: "urls") {
            arrayOfUrls.append((domain: parsedDomain, port: port))
            UserDefaults.standard.set(arrayOfUrls, forKey: "urls")
        } else {
            let newUrlArray = [(domain: parsedDomain, port: port)]
            UserDefaults.standard.set(newUrlArray, forKey: "urls")
        }
    }
    
    func getSettings() -> Settings {
        if var settings = UserDefaults.standard.object(forKey: "settings") {
            return settings as! UserSettings.Settings
        }
        UserDefaults.standard.set(settings, forKey: "settings")
  
    }
    
    static func savePort(_ port: Int) {
        UserDefaults.standard.set(port, forKey: "port")
    }
    
    static func saveDomain(_ domain: String) {
        UserDefaults.standard.set(domain, forKey: "domain")
    }
    
    static func updateUrl() {
        guard let domain = UserDefaults.standard.string(forKey: "domain") else { return }
        let port = UserDefaults.standard.integer(forKey: "port")
        let parsedDomain = UserSettings.parseDomain(domain)
        let parsedPort = UserSettings.parsePort(port)
        let url = "http://" + parsedDomain + ":" + String(parsedPort)
        UserDefaults.standard.set(url, forKey: "url")
    }

    static func parseDomain(_ domain: String) -> String {
        var parsedDomain = domain
        if domain.last == "/" {
            parsedDomain = String(domain.prefix(domain.count-1))
        }
        return parsedDomain
    }
    
    static func parsePort(_ port: Int) -> Int {
        var parsedPort = port
        if (port == 0) {
            parsedPort = 80
        }
        return parsedPort
    }
}
