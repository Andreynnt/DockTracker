//
//  SettingsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import CoreData

protocol SettingsViewControllerProtocol: class {
    func update(isConnected: Bool, description: String)
}

class SettingsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
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
    var servers = [ServerCoreData]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if let servers = ServerService.shared().servers {
            self.servers = servers
            let section = Sections(name: "Servers", fields: servers, footer: "Tracked servers")
            sections.append(section)
        }
        sections.append(Sections(name: "", fields: ["Add new"], footer: ""))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clickedServerNum = nil
        navigationController?.navigationBar.tintColor = Colors.secondColor
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (_, _, completion) in
            let server = self.servers[indexPath.row]
            if server.selected {
                self.selectedIndexPath = nil
                ServerService.shared().preferredServer = nil
            }
            self.servers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            CoreDataManager.instance.managedObjectContext.delete(server)
            CoreDataManager.instance.saveContext()
            completion(true)
        }
        action.image = UIImage(named: "icons8-waste-70")
        action.backgroundColor = Colors.thirdColor
        return action
    }
    
    @objc func clickOninfo(sender: UIButton) {
        performSegue(withIdentifier: segueToServer, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToServer {
            let viewController = segue.destination as! ServerViewController
            viewController.delegate = self
            if let num = clickedServerNum {
                viewController.server = servers[num]
            }
        }
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
        if servers.isEmpty {
            cell.fill(with: "No servers")
            return cell
        }
        let server = servers[indexPath.row]
        if server.selected {
            selectedIndexPath = indexPath
        }
        cell.delegate = self
        cell.fill(server: server)
        cell.infoButton.addTarget(self, action: #selector(clickOninfo), for: .touchUpInside)
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
        if num == serversSectionPosition {
            return servers.count
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
            return
        }
        
        if let savedIndexPath = selectedIndexPath {
            // был выбранный сервер
            let cell = tableView.cellForRow(at: savedIndexPath) as! SettingsTableViewCell
            if savedIndexPath == indexPath {
                ServerService.shared().getStatus(server: servers[indexPath.row]) { isAvailable, description in
                    cell.updateDescription(description: description)
                    let service = ServerService.shared()
                    service.preferredServerIsConnected = isAvailable
                    let url = service.getUrl(server: service.preferredServer!)
                    //update ContainersManager
                    ContainersManager.shared().clearAll()
                    ContainersManager.shared().getContainers(url: url)
                }
                return
            }
            cell.removeCheckmark()
        }
        
        let cell = tableView.cellForRow(at: indexPath) as! SettingsTableViewCell
        let server = servers[indexPath.row]
        ServerService.shared().getStatus(server: server) { isAvailable, description in
            cell.updateDescription(description: description)
            cell.addCheckmark()
            let service = ServerService.shared()
            ServerService.shared().preferredServerIsConnected = isAvailable
            let url = service.getUrl(server: service.preferredServer!)
              //update ContainersManager
            ContainersManager.shared().clearAll()
            ContainersManager.shared().getContainers(url: url)
        }
        if let savedIndexPath = selectedIndexPath {
            servers[savedIndexPath.row].selected = false
            if let cell = tableView.cellForRow(at: savedIndexPath) as? SettingsTableViewCell {
                cell.removeCheckmark()
            }
        }
        server.selected = true
        CoreDataManager.instance.saveContext()
        ServerService.shared().preferredServer = server
        selectedIndexPath = indexPath
    }
    
}

extension SettingsViewController: ServerViewControllerProtocol {
    func addServer(server: ServerCoreData) {
        let position = self.servers.count
        if position == 0 {
            //если это первый добавленный сервер, то он становится избранным
            //to do
        }
        self.servers.append(server)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: position, section: serversSectionPosition)], with: .automatic)
        tableView.endUpdates()
    }
    
    func changeServer(server: ServerCoreData) {
        guard let row = clickedServerNum else { return }
        self.servers[row] = server
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: serversSectionPosition)], with: .automatic)
        tableView.endUpdates()
        clickedServerNum = nil
    }
}

extension SettingsViewController: SettingsTableViewCellDelegate {
    func changeSelectedServerNum(_ sender: SettingsTableViewCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        clickedServerNum = tappedIndexPath.row
    }
}


