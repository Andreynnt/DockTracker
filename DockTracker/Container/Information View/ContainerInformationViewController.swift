//
//  ContainerInformationViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerInformationViewController: UIViewController, UITableViewDataSource, CellDelegate {

    var containerParameters = [СontainerParameter]()
    let containerParameterCellIdentifier = "containerParameterCellIdentifier"
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containerParameters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        let parameter = containerParameters[indexPath.row]
        cell = tableView.dequeueReusableCell(withIdentifier: containerParameterCellIdentifier, for: indexPath)
        if let castedCell = cell as? ContainerDataCell {
            castedCell.fillCell(with: parameter)
            castedCell.delegate = self
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }

    func contentDidChange() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
