//
//  ParametersTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 31/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func contentDidChange(cell: ContainerDataCell)
}

class ContainerDataCell: UITableViewCell {

    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var button: UIButton!
    
    weak var delegate: CellDelegate?
    var needHideText = false
    var fullTextIsShown = false
    
    var shortText: String?
    var fullText: String?
    let maxLength = 31
    
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
        fullText = parameter.value
        
        if parameter.value.count > maxLength {
            needHideText = true
            shortText = String(parameter.value.prefix(maxLength))
            shortText! += "..."
            value.text = shortText
            return
        }
        
        button.isHidden = true
        value.text = fullText
    }
    
    func changeText() {
        if fullTextIsShown {
            value.text = shortText
        } else {
            value.text = fullText
        }
        fullTextIsShown = !fullTextIsShown
        delegate?.contentDidChange(cell: self)
    }
    
    @IBAction func clickMoreButton(_ sender: UIButton) {
        changeText()
    }
    
}


