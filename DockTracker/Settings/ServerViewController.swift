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
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let placeholders = (
        domain: "Domain",
        port: "Port"
    )
    
    var server: ServerCoreData?
    var domain: String?
    var port: Int16?
    var delegate: ServerViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        domainField.delegate = self
        portField.delegate = self
        saveButton.tintColor = UIColor.lightGray
        domainField.addTarget(self, action: #selector(domainChanged), for: .editingChanged)
        portField.addTarget(self, action: #selector(portChanged), for: .editingChanged)
        if let server = server {
            port = server.port
            domain = server.server
            domainField.text = server.server
            portField.text = String(server.port)
            return
        }
        domainField.placeholder = placeholders.domain
        portField.placeholder = placeholders.port
    }
    
    @objc func domainChanged() {
        self.domain = getParsedDomain()
    }
    
    @objc func portChanged() {
        self.port = getParsedPort()
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if !canSave() {
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
        delegate?.addServer(server: server)
        CoreDataManager.instance.saveContext()
    }
    
    func changeServer(server: ServerCoreData) {
        server.server = domain!
        server.port = port!
        delegate?.changeServer(server: server)
        CoreDataManager.instance.saveContext()
    }
    
    func getParsedDomain() -> String? {
        if let domain = domainField.text, !domain.isEmpty {
            if port != nil {
                saveButton.tintColor = UIColor.blue
            }
            return domain
        }
        saveButton.tintColor = UIColor.lightGray
        return nil
    }
    
    func getParsedPort() -> Int16? {
        if let port = portField.text, !port.isEmpty {
            if domain != nil {
                saveButton.tintColor = UIColor.blue
            }
            if let parsedPort = Int16(port) {
                return parsedPort
            }
            return 80
        }
        saveButton.tintColor = UIColor.lightGray
        return nil
    }
    
    func canSave() -> Bool {
        if domain != nil && port != nil {
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //закрыть portField по клику на что-то другое
        portField.resignFirstResponder()
    }
    
}

extension ServerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
