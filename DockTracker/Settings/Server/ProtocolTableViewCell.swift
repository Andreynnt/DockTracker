//
//  ServerTableViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ProtocolTableViewCell: UITableViewCell {

    @IBOutlet weak var protocolLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fill(with text: String) {
        protocolLabel.text = text
    }
}
