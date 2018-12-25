//
//  ContainerInformationViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerInformationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CellDelegate {

    var containerParameters = [СontainerParameter]()
    let containerParameterCellIdentifier = "containerParameterCellIdentifier"
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containerParameters.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let parameter = containerParameters[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: containerParameterCellIdentifier, for: indexPath) as! ContainerDataCell
        cell.fillCell(with: parameter)
        cell.delegate = self
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(showFull), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let parameter = containerParameters[indexPath.row]
        return parameter.isCompact ? CGFloat(parameter.shortHeight) : CGFloat(parameter.fullHeight)
    }
    
    @objc func showFull(sender: UIButton) {
        tableView.beginUpdates()
        let indexPath = IndexPath(row: sender.tag, section: 0)
        containerParameters[indexPath.row].isCompact = false
        if let cell = tableView.cellForRow(at: indexPath) as? ContainerDataCell {
            UIView.animate(withDuration: 0.25) {
                cell.changeText()
            }
        }
        tableView.endUpdates()
    }

    func contentDidChange() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}
