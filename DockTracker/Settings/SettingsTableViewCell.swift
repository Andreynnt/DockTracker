//
//  ServerTableViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 28/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellDelegate: class {
    func changeSelectedServerNum(_ sender: SettingsTableViewCell)
}

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var port: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var checkmark: UILabel!
    
    var server: ServerCoreData?
    var delegate: SettingsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusLabel.text = "Tap to check connection"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addCheckmark() {
        checkmark.text = "✔"
    }
    
    func removeCheckmark() {
        checkmark.text = ""
    }
    
    @IBAction func infoButton(_ sender: UIButton) {
        if server != nil {
            delegate?.changeSelectedServerNum(self)
        }
    }
    
    func updateDescription(description: String) {
        statusLabel.text = description
    }
    
    func fill(server: ServerCoreData) {
        self.server = server
        port.text = ":" + String(server.port)
        domain.text = server.server
        statusLabel.textColor = Colors.thirdColor
        if server.selected {
            addCheckmark()
        }
    }
    
    func fill(with text: String) {
        domain.text = text
        statusLabel.text = ""
        port.text = ""
        infoButton.isHidden = true
    }
    
}
