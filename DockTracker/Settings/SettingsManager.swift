//
//  UserSettings.swift
//  DockTracker
//
//  Created by Андрей Бабков on 03/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import Foundation

class UserSettings {

    static func addUrl(domain: String, port: Int = 80) {
        var urls = getUrls()
        let parsedUrl = parseUrl(domain: domain, port: port)
        urls.append(parsedUrl)
        UserDefaults.standard.set(urls, forKey: "urls")
    }

    static func parseUrl(domain: String, port: Int) -> String {
        return parseDomain(domain) + ":" + String(parsePort(port))
    }

    static func printUrls() {
        let str = getUrls()
        print(str)
    }

    static func getUrls() -> [String] {
        if let urls = UserDefaults.standard.array(forKey: "urls") {
            return urls as! [String]
        }
        let newUrls = [String]()
        UserDefaults.standard.set(newUrls, forKey: "urls")
        return newUrls
    }

    static func getTuplesWithUrls() -> [(domain: String, port: Int)] {
        let urlsArray = getUrls()
        var urlsTupples = [(domain: String, port: Int)]()
        for url in urlsArray {
            if let tuple = getDomainAndPort(url) {
                urlsTupples.append(tuple)
            }
        }
        return urlsTupples
    }

    static func getDomains() -> [String] {
        let urlsArray = getUrls()
        print(urlsArray)
        var domainsArray = [String]()
        for url in urlsArray {
            if let tuple = getDomainAndPort(url) {
                domainsArray.append(tuple.domain)
            }
        }
        return domainsArray
    }

    static func getDomainAndPort(_ url: String) -> (domain: String, port: Int)? {
        if let range = url.range(of: ":") {
            let domain = url[..<range.lowerBound]
            let port = Int(url[range.upperBound..<url.endIndex])
            if port != nil {
                 return (String(domain), port!)
            }
        }
        return nil
    }

    static func getUrl(at num: Int = 0) -> String? {
        //uncomment if no urls
        //UserSettings.addUrl(domain: "andrey-babkov.ru", port: 5555)
        return "http://" + getUrls()[num]
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
        if port == 0 {
            parsedPort = 80
        }
        return parsedPort
    }

    static func clearUrls() {
        UserDefaults.standard.set([], forKey: "urls")
    }
}
