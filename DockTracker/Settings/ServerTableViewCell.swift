//
//  SettingsTableViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ServerTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    var callback: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fill(with text: String) {
        textField.placeholder = text
    }
    
}

extension ServerTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        callback?()
        return true
    }
}
