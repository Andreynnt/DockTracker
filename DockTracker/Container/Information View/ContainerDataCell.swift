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
    @IBOutlet weak var button: UIButton!
    private weak var name: UILabel?
    private weak var value: UITextView?
    
    weak var delegate: CellDelegate?
    var needHideText = false
    var fullTextIsShown = false

    var shortText: String?
    var fullText: String?
    var containerParameter: СontainerParameter?
    
    override func awakeFromNib() {
        self.clipsToBounds = true
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillCell(with containerParameter: СontainerParameter) {
        self.containerParameter = containerParameter
        if name == nil {
            let label = UILabel(frame: CGRect(x: 14, y: 7, width: bounds.width - 30, height: 25))
            addSubview(label)
            label.font = UIFont(name: "Montserrat-Regular", size: 15)
            name = label
        }

        if value == nil {
            //text view, потому что в label текст прыгает, тк он всегда в центре по вертикали
            let textView = UITextView(frame: CGRect(x: 10, y: 30, width: bounds.width - 50, height: 30))
            addSubview(textView)
            textView.font = UIFont(name: "Montserrat-Regular", size: 15)
            textView.textColor = UIColor.lightGray
            textView.isUserInteractionEnabled = false
            textView.isEditable = false
            textView.isSelectable = false
            value = textView
        }
        
        name?.text = containerParameter.name
        value?.text = containerParameter.value
        fullText = containerParameter.value

        if containerParameter.value.count > containerParameter.maxLineLength {
            needHideText = true
            shortText = String(containerParameter.value.prefix(containerParameter.maxLineLength))
            shortText! += "..."
            value?.text = shortText
            return
        }
        button.isHidden = true
        value?.text = fullText
    }

    func changeText() {
        if fullTextIsShown {
            return
        }
        if var frame = value?.frame {
            guard let containerParameter = containerParameter else { return }
            frame.size.height = CGFloat(containerParameter.fullHeight)
            value?.frame = frame
        }
        value?.text = fullText
        button.isHidden = true
        fullTextIsShown = !fullTextIsShown
    }

    @IBAction func clickMoreButton(_ sender: UIButton) {
        //changeText()
    }

}
