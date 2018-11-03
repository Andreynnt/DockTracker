//
//  ContainersViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var containersTable: UITableView!
    var containerModels = [Container]()
    var selectedContainer = Container()
    let cellIdentifier = "containerCell"
    var containerNum = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        UserSettings.saveUrl(domain: "andrey-babkov.ru", port: 5555)
        tableView.dataSource = self
        tableView.delegate = self
        getContainers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containerModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = containerModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if let castedCell = cell as? ContainerTableCell {
            castedCell.fillCell(with: model)
        }
        
        return cell
    }
    
    func getContainers() {
        guard let savedUrl = UserSettings.url else { return }
        let urlString = savedUrl + "/containers/json?all=1"
        print("url is: \(urlString)")
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
                DispatchQueue.main.async {
                    self.tableView.reloadData()
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
        
        var tmp = [Container]()
        for i in postsArray {
            guard let postDict = i as? NSDictionary,
                let container = Container(dict: postDict) else { continue }
            tmp.append(container)
        }
        self.containerModels = tmp
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedContainer = containerModels[indexPath.row]
        self.containerNum = indexPath.row
        performSegue(withIdentifier: "openContainer", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openContainer" {
            let container = segue.destination as! ContainerViewController
            container.container = selectedContainer
            container.changeContainersControllerState = changeContainerState
        }
    }
    
    func changeContainerState(_ newState: String) -> Void {
        containerModels[containerNum].state = newState
        let indexPath = IndexPath(item: containerNum, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @IBAction func pressReloadButton(_ sender: UIBarButtonItem) {
        getContainers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: index, animated: true)
        }
    }
}
