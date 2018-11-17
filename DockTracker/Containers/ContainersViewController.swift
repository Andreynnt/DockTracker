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
    var runningSectionNum = 0
    var stoppedSectionNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        getContainers(mainCallback: self.updateTable)
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
    
    func getContainers(mainCallback: (()-> Void)? = nil, callback: (()-> Void)? = nil) {
        guard let savedUrl = UserSettings.getUrl(at: 0) else { return }
        let urlString = savedUrl + "/containers/json?all=1"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                self.parseContainers(from: json)
                
                if (callback != nil) {
                    callback!()
                }
        
                guard let callbackInMain = mainCallback else { return }
                DispatchQueue.main.async {
                    callbackInMain()
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func parseContainers(from json: Any) {
        guard let postsArray = json as? NSArray else {
            print("Parse error")
            return
        }
        var allContainers = [Container]()
        for i in postsArray {
            guard let postDict = i as? NSDictionary,
                let container = Container(dict: postDict) else { continue }
            
            if (container.isStarted()) {
                sections[runningSectionNum].fields.append(container)
            } else {
                sections[stoppedSectionNum].fields.append(container)
            }
            allContainers.append(container)
        }
        ContainersManager.containers = allContainers
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
        return 70
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "containers-container" {
            let container = segue.destination as! ContainerViewController
            container.container = selectedContainer
            container.changeContainersControllerState = changeContainerState
        }
    }
    
    func changeContainerState(_ newState: String) -> Void {
//        containerModels[containerNum].state = newState
//        let indexPath = IndexPath(item: containerNum, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
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
    
    @IBAction func updatePage(_ sender: Any) {
        if reloadButtonIsBlocked { return }
        blockReloadButton()
        clearData()
        getContainers(mainCallback: {() -> Void in
            self.blockReloadButton()
            self.updateTable()
        })
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
    
    func blockReloadButton() {
        reloadButtonIsBlocked = !reloadButtonIsBlocked
    }
}
