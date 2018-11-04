//
//  SettingsViewController.swift
//  DockTracker
//
//  Created by Андрей Бабков on 04/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    struct Sections {
        var name: String!
        var fields: [String]!
        var footer: String!
    }
    
    var sections = [Sections]()
    var currentSectionNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        sections = [Sections(name: "Servers", fields: ["andrey-babkov.ru", "google.com"], footer: "Tracked servers"),
                    Sections(name: "", fields: ["Add new"], footer: ""),
                    Sections(name: "Account", fields: ["Your name"], footer: "Yout account information")
        ]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currentSectionNum == sections.first?.fields.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: "settingsButtonCell", for: indexPath)
                currentSectionNum += 1
                if let castedCell = cell as? ButtonCell {
                    castedCell.fillCell(with: sections[indexPath.section].fields[indexPath.row])
                    return castedCell
                }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell", for: indexPath)
        cell.textLabel?.text = sections[indexPath.section].fields[indexPath.row]
        currentSectionNum += 1
        return cell
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
    
        
}
