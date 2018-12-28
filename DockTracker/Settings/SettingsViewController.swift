//
//  SettingsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "ServerCoreData", keyForSort: "server")

    struct Sections {
        var name: String!
        var fields: [Any]
        var footer: String!
    }
    let buttonSectionPosition = 0
    let serversSectionPosition = 1
    var segueToServer = "openServer"
    
    var sections = [Sections]()
    var servers: [ServerCoreData]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        servers = fetchServers()
        tableView.dataSource = self
        tableView.delegate = self
        sections = [
            Sections(name: "", fields: ["Add new"], footer: "")
        ]
        if let servers = servers {
            let section =  Sections(name: "Servers", fields: servers, footer: "Tracked servers")
            sections.append(section)
        }
    }
    
    func fetchServers() -> [ServerCoreData]? {
        do {
            try self.fetchedResultsController.performFetch()
            return self.fetchedResultsController.fetchedObjects as? [ServerCoreData]
        } catch {
            print(error)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == buttonSectionPosition {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsButtonCell", for: indexPath)
            if let castedCell = cell as? ButtonCell {
                let text = sections[indexPath.section].fields.first as! String
                castedCell.fillCell(with: text)
                castedCell.selectionStyle = .none
                return castedCell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath) as! SettingsTableViewCell
        if let servers = servers, !servers.isEmpty {
             let server = servers[indexPath.row]
             cell.fill(server: server)
             return cell
        }
        cell.fill(with: "No servers")
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection num: Int) -> Int {
        if num == serversSectionPosition && servers!.isEmpty {
            return 1
        }
        return sections[num].fields.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].name
    }

    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == buttonSectionPosition {
                performSegue(withIdentifier: segueToServer, sender: self)
        }
    }
}
