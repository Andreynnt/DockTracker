//
//  NumberOfLogsCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 24/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class NumberOfLogsCell: UITableViewCell {
    @IBOutlet var numLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func fill(with value: String) {
        if (value == "-1") {
            numLabel.text = "all"
            return
        }
        numLabel.text = value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
