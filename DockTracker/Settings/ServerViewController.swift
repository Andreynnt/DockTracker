//
//  ServerViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 07/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ServerViewController: UIViewController {
    @IBOutlet weak var domainField: UITextField!
    @IBOutlet weak var portField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let placeholders = (
        domain: "Domain",
        port: "Port"
    )
    var domain: String?
    var port: Int16?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        domainField.delegate = self
        portField.delegate = self
        domainField.placeholder = placeholders.domain
        portField.placeholder = placeholders.port
        saveButton.tintColor = UIColor.lightGray
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if !canSave() {
            return
        }
        let server = ServerCoreData()
        server.server = domain!
        server.port = port!
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
            return Int16(port)!
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
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        port = getParsedPort()
        domain = getParsedDomain()
    }
}


