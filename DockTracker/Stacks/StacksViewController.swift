//
//  ContainersViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class StacksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containersTable: UITableView!
    
    var containers = [Container]()
    var selectedContainer = Container()
    var groupedContainers = [String: [Container]]()
    var idArray = [String]()
    var containerNum = 0
    var reloadButtonIsBlocked = false
    let cellIdentifier = "containerCell"
    var selectedId: String!
    
    lazy var refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refreshControll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettings.clearUrls()
        UserSettings.addUrl(domain: "andrey-babkov.ru", port: 5555)
        UserSettings.addUrl(domain: "mail.ru", port: 88)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresher
        tableView.separatorStyle = .none
        navigationController?.hidesBarsOnSwipe = true
        fillStacksView(ContainersManager.shared().containers)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedContainers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = idArray[indexPath.row]
        let groupOfContainers = groupedContainers[id]
        let amount = groupOfContainers?.count
        let imageName = groupOfContainers?.first?.image.value ?? "No name"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let castedCell = cell as? StackTableCell {
            castedCell.fillCell(with: (imageName, amount!))
        }
        return cell
    }
    
    func fillStacksView(_ containersFromManager: [Container]) {
        for container in containersFromManager {
            if groupedContainers[container.imageId.value] != nil {
                groupedContainers[container.imageId.value]?.append(container)
            } else {
                groupedContainers[container.imageId.value] = [container]
                idArray.append(container.imageId.value)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedId = idArray[indexPath.row]
        performSegue(withIdentifier: "openGroup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openGroup" {
            let groupOfContainers = groupedContainers[self.selectedId]
            let groupController = segue.destination as! StackViewController
            groupController.containers = groupOfContainers!
        }
    }
    
    func changeContainerState(_ newState: String) -> Void {
        containers[containerNum].state.value = newState
        let indexPath = IndexPath(item: containerNum, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func clearData() {
        containers.removeAll()
        groupedContainers.removeAll()
        selectedContainer = Container()
        containerNum = 0
    }

    func updateTable() {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc
    func refreshTable() {
        ContainersManager.shared().getContainers(mainCallback: {() -> Void in
            self.updateTable()
            self.refresher.endRefreshing()
        }, callback: { (_ containers: [Container]) -> Void in
            self.clearData()
            self.fillStacksView(containers)
        })
    }
}
