//
//  TextFieldViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/12/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class TextFieldViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    
    var positionNum: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fill(with text: String, num: Int) {
        textField.placeholder = text
        positionNum = num
    }
    
    func fill(with text: String) {
        textField.text = text
    }

}

extension TextFieldViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
