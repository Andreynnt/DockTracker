//
//  ParametersTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 31/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func contentDidChange()
}

class ContainerDataCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var button: UIButton!
    
    
    weak var delegate: CellDelegate?
    var needHideText = false
    var fullTextIsShown = false
    
    var shortText: String?
    var fullText: String?
    let maxLength = 31
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(with containerParameter: СontainerParameter) {
        self.name.text = containerParameter.name
        self.value.text = containerParameter.value
        fullText = containerParameter.value
        
        if containerParameter.value.count > maxLength {
            needHideText = true
            shortText = String(containerParameter.value.prefix(maxLength))
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
        delegate?.contentDidChange()
    }
    
    @IBAction func clickMoreButton(_ sender: UIButton) {
        changeText()
    }
    
}


