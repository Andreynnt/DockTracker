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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
        let favourite = importantAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete, favourite])
    }
    
    func importantAction(at indexPath: IndexPath) -> UIContextualAction {
        if self.containers[indexPath.row].isFavourite {
            let style = section == ContainersSection.Favourite ? UIContextualAction.Style.destructive : UIContextualAction.Style.normal
            let action = UIContextualAction(style: style, title: "Delete imporatant") { (action, _, completion) in
                self.containers[indexPath.row].isFavourite = false
                ContainersManager.shared().deleteFromFavourites(container: self.containers[indexPath.row], section: self.section, num: indexPath.row)
                completion(true)
                //если мы в избранном, то удалять строчку
            }
            action.backgroundColor = Colors.secondColor
            action.image = UIImage(named: "icons8-dislike-80")
            action.backgroundColor = Colors.secondColor
            return action
        }
        let action = UIContextualAction(style: .normal, title: "Add imporatant") { (action, _, completion) in
            self.containers[indexPath.row].isFavourite = true
            ContainersManager.shared().addToFavourite(container: self.containers[indexPath.row],
                                                      section: self.section, num: indexPath.row)
            completion(true)
        }
        action.image = UIImage(named: "icons8-heart-outline-90")
        action.backgroundColor = Colors.secondColor
        return action
    }

    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, _, completion) in
            let container = self.containers[indexPath.row]
            self.containers.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            if container.isFavourite {
                ContainersManager.shared().deleteFromFavourites(container: container, section: self.section, num: indexPath.row)
            } else {
                ContainersManager.shared().deleteCommonContainerFromArray(at: indexPath.row, section: self.section)
            }
            self.deleteContainerFromServer(id: container.id.value)
            completion(true)
        }
        action.image = UIImage(named: "icons8-waste-70")
        action.backgroundColor = Colors.thirdColor
        return action
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containers-container" {
            let containerView = segue.destination as! ContainerViewController
            containerView.container = selectedContainer
            containerView.section = section
            containerView.containerNum = containerNum
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }

    func deleteContainerFromServer(id: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(id)"
        let url = URL(string: urlString)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }.resume()
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
