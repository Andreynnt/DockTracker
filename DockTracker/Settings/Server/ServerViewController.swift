//
//  ServerViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 07/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol ServerViewControllerProtocol: class {
    func addServer(server: ServerCoreData)
    func changeServer(server: ServerCoreData)
}

class ServerViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    struct Section {
        var name: String!
        var fields: [String]
        var footer: String!
    }
    
    let sections = [
        Section(name: "Protocol", fields: ["http", "https"], footer: ""),
        Section(name: "Connection", fields: ["Domain", "Port"], footer: "")
    ]
    
    //todo убрать
    var domainField: UITextField?
    var portField: UITextField?
    
    var server: ServerCoreData?
    var domain: String?
    var port: Int16?
    var webProtocol = "http"
    var selectedProtocolIndexPath = IndexPath(row: 0, section: 0)
    var delegate: ServerViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        saveButton.tintColor = UIColor.lightGray
       
        if let server = server {
            port = server.port
            domain = server.server
            webProtocol = server.webProtocol ?? "http"
            let row = webProtocol == "http" ? 0 : 1
            selectedProtocolIndexPath = IndexPath(row: row, section: 0)
        }
    }
    
    @objc func domainChanged() {
        self.domain = getParsedDomain()
        changeSaveButtonColor()
    }
    
    @objc func portChanged() {
        self.port = getParsedPort()
        changeSaveButtonColor()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if !canSave() {
            return
        }
        if !needUpdateServer() {
            return
        }
        
        if let savedServer = self.server {
            changeServer(server: savedServer)
        } else {
            createServer()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func createServer() {
        let server = ServerCoreData()
        server.server = domain!
        server.port = port!
        server.webProtocol = webProtocol
        delegate?.addServer(server: server)
        CoreDataManager.instance.saveContext()
    }
    
    func changeServer(server: ServerCoreData) {
        server.server = domain!
        server.port = port!
        server.webProtocol = webProtocol
        delegate?.changeServer(server: server)
        CoreDataManager.instance.saveContext()
    }
    
    func getParsedDomain() -> String? {
        guard let domain = domainField?.text else {
            saveButton.tintColor = UIColor.lightGray
            return nil
        }
        if !domain.isEmpty {
            if port != nil {
                saveButton.tintColor = Colors.thirdColor
            }
            return domain
        }
        domainField?.placeholder = "Domain"
        saveButton.tintColor = UIColor.lightGray
        return nil
    }
    
    func getParsedPort() -> Int16? {
        guard let port = portField?.text else {
            saveButton.tintColor = UIColor.lightGray
            return nil
        }
        if !port.isEmpty {
            if domain != nil {
                saveButton.tintColor = Colors.thirdColor
            }
            if let parsedPort = Int16(port) {
                return parsedPort
            }
            return 80
        }
        portField?.placeholder = "Port"
        saveButton.tintColor = UIColor.lightGray
        return nil
    }
    
    func canSave() -> Bool {
        if domain != nil && port != nil {
            return true
        }
        return false
    }
    
    func needUpdateServer() -> Bool {
        if canSave() {
            guard let server = server else {
                //создание нового сервера
                return true
            }
            if domain! == server.server!
                && port! == server.port && webProtocol == server.webProtocol {
                return false
            }
            return true
        }
        return false
    }
    
    func changeSaveButtonColor() {
        if needUpdateServer() {
            saveButton.tintColor = Colors.thirdColor
        } else {
            saveButton.tintColor = UIColor.lightGray
        }
    }
}

extension ServerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProtocolTableViewCell") as! ProtocolTableViewCell
            cell.fill(with: sections[indexPath.section].fields[indexPath.row])
            if indexPath == selectedProtocolIndexPath {
                cell.accessoryType = .checkmark
            }
            cell.tintColor = Colors.thirdColor
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldViewCell") as! TextFieldViewCell
        if indexPath.row == 0 {
            domainField = cell.textField
            cell.textField.addTarget(self, action: #selector(domainChanged), for: .editingChanged)
        } else {
            portField = cell.textField
            cell.textField.keyboardType = .numberPad
            cell.textField.addTarget(self, action: #selector(portChanged), for: .editingChanged)
        }
        
        if let server = server {
            if indexPath.row == 0 {
                cell.fill(with: server.server!)
            } else {
                cell.fill(with: String(server.port))
            }
        } else {
            cell.fill(with: sections[indexPath.section].fields[indexPath.row], num: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && selectedProtocolIndexPath != indexPath {
            if indexPath.row == 0 {
                webProtocol = "http"
            } else {
                webProtocol = "https"
            }
            changeSaveButtonColor()
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            tableView.cellForRow(at: selectedProtocolIndexPath)?.accessoryType = .none
            selectedProtocolIndexPath = indexPath
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
