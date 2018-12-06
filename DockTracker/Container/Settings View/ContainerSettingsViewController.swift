//
//  ContainerSettingsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedIndexPath: IndexPath?
    var selectedValue = -1
    weak var logsSwichDelegate: LogsDateSwitchCellDelegate?
    weak var logsAmountDelegate: ChoiceOfLogsAmountCellDelegate?

    struct Sections {
        var name: String!
        var fields: [Int]
        var footer: String!
    }

    var sections = [
        Sections(name: "", fields: [1], footer: ""),
        Sections(name: "Number of logs", fields: [-1, 10, 100, 500, 1000, 3000],
                 footer: "Only return this number of log lines from the end of the logs")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogsDateSwitchCell",
                                                     for: indexPath) as! LogsDateSwitchCell
            cell.dateSwitch.onTintColor = Colors.secondColor
            cell.delegate = self.logsSwichDelegate
            cell.selectionStyle = .none
            return cell
        }

        let logsAmount = sections[indexPath.section].fields[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceOfLogsAmountCell", for: indexPath)
        if let castedCell = cell as? ChoiceOfLogsAmountCell {
            castedCell.delegate = self.logsAmountDelegate
            castedCell.fill(with: logsAmount)
            if selectedValue == logsAmount {
                selectedIndexPath = indexPath
                castedCell.tintColor = Colors.secondColor
                castedCell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
        }
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        if selectedIndexPath != nil {
            if selectedIndexPath == indexPath {
                return
            }
            tableView.cellForRow(at: selectedIndexPath!)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        selectedValue = sections[indexPath.section].fields[indexPath.row]
        selectedIndexPath = indexPath
        logsAmountDelegate?.changeAmountOfLogs(amount: selectedValue)
        tableView.cellForRow(at: indexPath)?.tintColor = Colors.secondColor
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
    }
}
