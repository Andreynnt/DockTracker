//
//  UserSettings.swift
//  DockTracker
//
//  Created by Андрей Бабков on 03/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation


class UserSettings {
    
    static var url: String? {
        return UserDefaults.standard.string(forKey: "url")
    }
    
    static func saveUrl(domain: String, port: Int = 80) {
        let parsedDomain = parseDomain(domain)
        let url = "http://" + parsedDomain + ":" + String(port);
        UserDefaults.standard.set(url, forKey: "url")
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
