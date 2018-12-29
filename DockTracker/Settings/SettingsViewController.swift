//
//  SettingsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController = CoreDataManager.instance
        .fetchedResultsController(entityName: "ServerCoreData", keyForSort: "server")
    struct Sections {
        var name: String!
        var fields: [Any]
        var footer: String!
    }
    let buttonSectionPosition = 1
    let serversSectionPosition = 0
    var segueToServer = "openServer"
    var clickedServerNum: Int?
    var sections = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if let servers = fetchServers() {
            let section = Sections(name: "Servers", fields: servers, footer: "Tracked servers")
            sections.append(section)
        }
        sections.append(Sections(name: "", fields: ["Add new"], footer: ""))
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

    @objc func clickOninfo(sender: UIButton) {
        clickedServerNum = sender.tag
        performSegue(withIdentifier: segueToServer, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToServer {
            let viewController = segue.destination as! ServerViewController
            viewController.delegate = self
            if let serverNum = clickedServerNum {
                viewController.server = (self.sections[serversSectionPosition].fields[serverNum] as! ServerCoreData)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clickedServerNum = nil
        navigationController?.navigationBar.tintColor = Colors.secondColor
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            guard let servers = self.sections[indexPath.section].fields as? [ServerCoreData] else { return }
            let server = servers[indexPath.row]
            self.sections[indexPath.section].fields.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.instance.managedObjectContext.delete(server)
            CoreDataManager.instance.saveContext()
            completion(true)
        }
        action.image = UIImage(named: "icons8-waste-70")
        action.backgroundColor = Colors.thirdColor
        return action
    }
    
}

// MARK: table view delegates & data source
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
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
        if let servers = sections[indexPath.section].fields as? [ServerCoreData], !servers.isEmpty {
            let server = servers[indexPath.row]
            cell.fill(server: server)
            cell.infoButton.tag = indexPath.row
            cell.infoButton.addTarget(self, action: #selector(clickOninfo), for: .touchUpInside)
            return cell
        }
        cell.fill(with: "No servers")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == buttonSectionPosition {
            return 40
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let delete = deleteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection num: Int) -> Int {
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

extension SettingsViewController: ServerViewControllerProtocol {
    func addServer(server: ServerCoreData) {
        let position = self.sections[serversSectionPosition].fields.count
        self.sections[serversSectionPosition].fields.append(server)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: position, section: serversSectionPosition)], with: .automatic)
        tableView.endUpdates()
    }
    
    func changeServer(server: ServerCoreData) {
        guard let row = clickedServerNum else { return }
        self.sections[serversSectionPosition].fields[row] = server
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: serversSectionPosition)], with: .automatic)
        tableView.endUpdates()
        clickedServerNum = nil
    }
}
