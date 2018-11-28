//
//  ContainersViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 09/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var selectedContainer = Container()
    let cellIdentifier = "containerCell"
    let emptyCellIdentificator = "empty-cell"
    var containerNum = 0
    var runningSectionNum = 0
    var stoppedSectionNum = 1
    
    
    var reloadButtonIsBlocked = false
    var noRunningContainers = false
    var noStoppedContainers = false
    
    struct Sections {
        var name: String!
        var fields: [Container]!
        var footer: String!
    }
    
    var sections = [
        Sections(name: "Working containers", fields: [Container](), footer: "Running and paused containers"),
        Sections(name: "Stopped containers", fields: [Container](), footer: "Containers wich were stopped by user or error")
    ]

    lazy var refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refreshControll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettings.addUrl(domain: "andrey-babkov.ru", port: 5555)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresher
        tableView.separatorStyle = .none
        tableView.backgroundView = nil;
        tableView.backgroundColor = UIColor.white
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        fillContainers(ContainersManager.shared().containers)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if noRunningContainers == true && indexPath.section == runningSectionNum && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentificator, for: indexPath)
            return cell
        } else if noStoppedContainers == true && indexPath.section == stoppedSectionNum && indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentificator, for: indexPath)
            return cell
        }
        
        let model = sections[indexPath.section].fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
    
        if let castedCell = cell as? ContainerTableViewCell {
            castedCell.fillCell(with: model)
        }
        return cell
    }
    
    func fillContainers(_ containersFromManager: [Container]) {
        for container in containersFromManager {
            if (container.isStarted()) {
                    sections[runningSectionNum].fields.append(container)
            } else {
                    sections[stoppedSectionNum].fields.append(container)
            }
        }
        checkIfSectionsAreEmpty()
    }
    
    func checkIfSectionsAreEmpty() {
        if sections[runningSectionNum].fields.isEmpty {
            let emptyContainer = Container()
            sections[runningSectionNum].fields.append(emptyContainer)
            self.noRunningContainers = true
        } else {
             self.noRunningContainers = false
        }
        
        if sections[stoppedSectionNum].fields.isEmpty {
            let emptyContainer = Container()
            sections[stoppedSectionNum].fields.append(emptyContainer)
            self.noStoppedContainers = true
        } else {
            self.noStoppedContainers = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContainer = sections[indexPath.section].fields[indexPath.row]
        self.containerNum = indexPath.row
        performSegue(withIdentifier: "containers-container", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noRunningContainers && indexPath.section == runningSectionNum {
            return 50
        }
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containers-container" {
            let containerView = segue.destination as! ContainerViewController
            containerView.container = selectedContainer
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
        //navigationController?.hidesBarsOnSwipe = true
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
    
    func updateTable() {
        self.tableView.reloadData()
    }
    
    func clearData() {
        let lastIndex = sections.count - 1
        for i in 0...lastIndex {
            sections[i].fields.removeAll()
        }
    }
    
    @objc
    func refreshTable() {
        ContainersManager.shared().getContainers(mainCallback: {() -> Void in
            self.updateTable()
            self.refresher.endRefreshing()
        }, callback: { (_ containers: [Container]) -> Void in
            self.clearData()
            self.fillContainers(containers)
        })
    }
}

