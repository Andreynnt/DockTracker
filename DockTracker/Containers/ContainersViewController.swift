//
//  ContainersViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 09/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit
import CoreData

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

    var containers = [Container]()
    
    //секция, из которой попали в эту вьюху
    var section: ContainersSection?

    lazy var refresher: UIRefreshControl = {
        let refreshControll = UIRefreshControl()
        refreshControll.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return refreshControll
    }()
    
    var fetchController = ContainersManager.shared().fetchedResultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UserSettings.addUrl(domain: "andrey-babkov.ru", port: 5555)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refresher
        tableView.separatorStyle = .none
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.white
        navigationController?.title = "Containers"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = containers[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        if let castedCell = cell as? ContainerTableViewCell {
            castedCell.fillCell(with: model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContainer = containers[indexPath.row]
        self.containerNum = indexPath.row
        performSegue(withIdentifier: "containers-container", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let favourite = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, favourite])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        //print("Name is = \(self.containers[indexPath.row].name.value) and fav = \(self.containers[indexPath.row].isFavourite)")
        if self.containers[indexPath.row].isFavourite {
            let action = UIContextualAction(style: .normal, title: "Delete from imporatant") { (action, _, completion) in
                self.containers[indexPath.row].isFavourite = false
                ContainersManager.shared().deleteFromFavourites(container: self.containers[indexPath.row], section: self.section, num: indexPath.row)
                action.backgroundColor = UIColor.green
                completion(true)
                //если мы в избранном, то удалять строчку
            }
            action.backgroundColor = UIColor.green
            return action
        }
        let action = UIContextualAction(style: .normal, title: "Add to imporatant") { (action, _, completion) in
            self.containers[indexPath.row].isFavourite = true
            ContainersManager.shared().addToFavourite(container: self.containers[indexPath.row], section: self.section, num: indexPath.row)
            action.backgroundColor = UIColor.green
            completion(true)
        }
        action.backgroundColor = UIColor.green
        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, _, completion) in
            let container = self.containers[indexPath.row]
            self.containers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            //print("Name is = \(container.name.value) and fav = \(container.isFavourite)")
            //print("Name is = \(container.name.value) and fav = \(container.isFavourite)")
            if container.isFavourite {
                ContainersManager.shared().deleteFromFavourites(container: container, section: self.section, num: indexPath.row)
            }
            //TO DO
            self.deleteContainerFromServer()
            action.backgroundColor = UIColor.red
            completion(true)
        }
        return action
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
    }

    func deleteContainerFromServer() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection num: Int) -> Int {
        return containers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if noRunningContainers && indexPath.section == runningSectionNum {
            return 50
        }
        return 80
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func updateTable() {
        self.tableView.reloadData()
    }

    func clearData() {
        containers.removeAll()
    }

    @objc
    func refreshTable() {
        ContainersManager.shared().getContainers(mainCallback: {() -> Void in
            self.updateTable()
            self.refresher.endRefreshing()
        }, callback: { (_ containers: [Container]) -> Void in
            self.clearData()
            //TO DO DOEST WORKING
            //self.fillContainers(containers)
        })
    }
}
