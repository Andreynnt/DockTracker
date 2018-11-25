//
//  ContainerViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet var logsButton: UIButton!
    
    var container = Container()
    var numberOfLogs = -1
    var needLogsDates = false
    var numberOfLogsCell: NumberOfLogsCell?
 
    var changeContainersControllerState: ((_ newSate: String) -> Void)?
    var stateFieldNum = -1
    
    //segues names
    let openLogsSegue = "openLogs"
    let openNumberOfLogsSegue = "openNumberOfLogs"
    
    //cells names
    let containerDataCellIdentifier = "ContainerDataCell"
    let LogsDateCellIdentifier = "LogsDateCell"
    let numberOfLogsCellIdentifier = "NumberOfLogsCell"
    
    struct ParametersSections {
        var name: String!
        var fields: [Any]!
        var footer: String!
    }
    
    var sections = [
        ParametersSections(name: "Container's information", fields: [СontainerParameter](), footer: ""),
        ParametersSections(name: "Options", fields: ["Date switch", "NumberOfLogsCell"], footer: "Logs options"),
        //пустые секции в самом конце, чтобы было расстояние над кнопками
        ParametersSections(name: "", fields: [String](), footer: ""),
        ParametersSections(name: "", fields: [String](), footer: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if container.state.value == "running" {
            self.startStopButton.setTitle("Stop", for: .normal)
        }
        sections[0].fields = container.getParametersArray()
        makeButtonStylish(startStopButton)
        makeButtonStylish(logsButton)
        self.navigationItem.title = container.name.value
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }
    
    func makeButtonStylish(_ button: UIButton!) {
        button.layer.cornerRadius = button.frame.height / 2
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowRadius = 3
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if indexPath.section == 0 {
            let parameter = sections[indexPath.section].fields[indexPath.row]
            cell = tableView.dequeueReusableCell(withIdentifier: containerDataCellIdentifier, for: indexPath)
            if let castedCell = cell as? ContainerDataCell {
                castedCell.fillCell(with: parameter as! СontainerParameter)
                castedCell.delegate = self
            }
        } else if indexPath.section == 1 && indexPath.row == 1 {
            cell = tableView.dequeueReusableCell(withIdentifier: numberOfLogsCellIdentifier, for: indexPath)
            if let castedCell = cell as? NumberOfLogsCell {
                castedCell.fill(with: String(numberOfLogs))
                numberOfLogsCell = castedCell
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: LogsDateCellIdentifier, for: indexPath)
            if let castedCell = cell as? LogsDateSwitchCell {
                castedCell.delegate = self
            }
        }
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    
    @IBAction func startStopContainer(_ sender: UIButton) {
        if (container.isStarted()) {
            stopContainer(with: container.name.value)
        } else {
            startContainer(with: container.name.value)
        }
    }
    
    func startContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/start?p=80:3000"
      
        self.startStopButton.setTitle("Starting", for: .normal)
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }
            
            switch httpResponse.statusCode {
            case 204:
                DispatchQueue.main.async {
                    self.container.state.value = "running"
                    self.changeContainersControllerState?("running")
                     self.changeMainButtonTitle("Stop")
                }
            case 304:
                print("Container already started")
                self.changeMainButtonTitle("Start")
            case 500:
                print("Server error")
                self.changeMainButtonTitle("Start")
            default:
                print("Unexpected error")
                self.changeMainButtonTitle("Start")
            }
        }.resume()
    }
    
    func stopContainer(with name: String) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/\(name)/stop"
        
        self.startStopButton.setTitle("Stopping", for: .normal)
        print("Going to request \(urlString)")
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Can't httpResponse = response as? HTTPURLResponse")
                return
            }
            
            switch httpResponse.statusCode {
            case 204:
                print("Successful stop")
                DispatchQueue.main.async {
                    self.container.state.value = "exited"
                    self.changeContainersControllerState?("exited")
                    self.changeMainButtonTitle("Start")
                }
            case 304:
                print("Container already stopped")
                self.changeMainButtonTitle("Stop")
            case 500:
                print("Server error")
                self.changeMainButtonTitle("Stop")
            default:
                print("Unexpected error")
                self.changeMainButtonTitle("Stop")
            }
       }.resume()
    }
    
    func changeMainButtonTitle(_ status: String) {
        DispatchQueue.main.async {
            self.startStopButton.setTitle(status, for: .normal)
        }
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
        if (indexPath.section == 1 && indexPath.row == 1) {
            performSegue(withIdentifier: openNumberOfLogsSegue, sender: self)
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        if let castedCell = cell as? ContainerDataCell {
            if castedCell.needHideText {
                castedCell.changeText()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
    
    @IBAction func touchLogsButton(_ sender: UIButton) {
        performSegue(withIdentifier: openLogsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == openLogsSegue {
            let logsView = segue.destination as! LogsViewController
            logsView.containerName = container.name.value
            logsView.needDates = needLogsDates
            logsView.tail = String(numberOfLogs)
        }
        if segue.identifier == openNumberOfLogsSegue {
            let view = segue.destination as! ChoiceOfLogsAmountController
            view.selectedValue = numberOfLogs
            view.delegate = self
        }
    }
}

extension ContainerViewController: CellDelegate {
    func contentDidChange() {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension ContainerViewController: ChoiceOfLogsAmountControllerDelegate {
    func changeAmountOfLogs(amount: Int) {
        self.numberOfLogs = amount
        self.numberOfLogsCell?.fill(with: String(amount))
    }
}

extension ContainerViewController: LogsDateSwitchCellDelegate {
    func chageNeedLogs(need: Bool) {
        self.needLogsDates = need
    }
}
