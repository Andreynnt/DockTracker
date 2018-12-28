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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(server: ServerCoreData) {
        port.text = String(server.port)
        domain.text = server.server
    }
    
    func fill(with text: String) {
        domain.text = text
        port.text = ""
    }

}
