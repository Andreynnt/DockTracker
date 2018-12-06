//
//  containerGroupsController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 06/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class StackViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var containers = [Container]()
    let cellIdentifier = "container"
    var selectedContainerNum: Int!
    var mainTitle: String?

    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.white
        self.title = mainTitle ?? "Containers"
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let castedCell = cell as? ContainerInStackCell {
            castedCell.fillCell(with: containers[indexPath.row].name.value)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedContainerNum = indexPath.row
        performSegue(withIdentifier: "openContainer", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openContainer" {
            let container = segue.destination as! ContainerViewController
            container.container = containers[selectedContainerNum]
            //container.changeContainersControllerState = changeContainerState
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}
