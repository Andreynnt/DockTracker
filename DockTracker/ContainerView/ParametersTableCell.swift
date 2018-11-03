//
//  ParametersTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 31/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ParametersTableCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(with parameter: (name: String, value: String)) {
        self.name.text = parameter.name
        self.value.text = parameter.value
    }

}
