//
//  ServerTableViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 28/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var port: UILabel!
    @IBOutlet weak var domain: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(server: ServerCoreData) {
        port.text = ":" + String(server.port)
        domain.text = server.server
        statusLabel.textColor = Colors.thirdColor
        statusLabel.text = "Active"
    }
    
    func fill(with text: String) {
        domain.text = text
        statusLabel.text = ""
        port.text = ""
        infoButton.isHidden = true
    }
    
}
