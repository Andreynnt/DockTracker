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
    @IBOutlet weak var mainButton: UIButton!
    
    var container = Container()
    var parameteres = [(name: String, value: String)]()
    var changeContainersControllerState: ((_ newSate: String) -> Void)?
    var stateFieldNum = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if container.state == "running" {
            self.mainButton.setTitle("Stop", for: .normal)
        }
        mainButton.layer.cornerRadius = 20
        mainButton.clipsToBounds = true
        self.navigationItem.title = container.image
        setParametersArray(container)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func setParametersArray(_ container: Container) {
        let bookMirror = Mirror(reflecting: container)
        for (name, value) in bookMirror.children {
            if let stringValue = value as? String {
                let parameter = (name: name!, value: stringValue)
                parameteres.append(parameter)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parameteres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let parameter = parameteres[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "containerCell", for: indexPath)
        
        if let castedCell = cell as? ParametersTableCell {
            castedCell.fillCell(with: parameter)
        }
        return cell
    }
    
    @IBAction func clickMainButton(_ sender: UIButton) {
        if (container.isStarted()) {
            stopContainer(with: container.name)
        } else {
            startContainer(with: container.name)
        }
    }

    func startContainer(with name: String) {
        guard let savedUrl = UserSettings.url else { return }
        let urlString = savedUrl + "/containers/\(name)/start?p=80:3000"
      
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
                print("Successful start")
                DispatchQueue.main.async {
                    self.container.state = "running"
                    self.changeContainersControllerState?("running")
                    self.mainButton.setTitle("Stop", for: .normal)
                    let i = self.searchStatusRow()
                    if (i >= 0) {
                        self.changeContainerState("running", i)
                    }
                }
            case 304:
                print("Container already started")
            case 500:
                print("Server error")
            default:
                print("Unexpected error")
            }
        }.resume()
    }
    
    func stopContainer(with name: String) {
        guard let savedUrl = UserSettings.url else { return }
        let urlString = savedUrl + "/containers/\(name)/stop"
        
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
                    self.container.state = "exited"
                    self.changeContainersControllerState?("exited")
                    self.mainButton.setTitle("Start", for: .normal)
                    let i = self.searchStatusRow()
                    if (i >= 0) {
                        self.changeContainerState("exited", i)
                    }
                }
            case 304:
                print("Container already stopped")
            case 500:
                print("Server error")
            default:
                print("Unexpected error")
            }
       }.resume()
    }
    
    func changeContainerState(_ newState: String, _ num: Int) -> Void {
        parameteres[num].value = newState
        let indexPath = IndexPath(item: num, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }

    
    func searchStatusRow() -> Int {
        if let statusFieldNum = parameteres.index(where: { (item) -> Bool in
            item.name == "state"
        }) {
            return statusFieldNum
        }
        return -1
    }
}
