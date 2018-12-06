//
//  ContainerTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class StackTableCell: UITableViewCell {

    @IBOutlet var containersAmountLabel: UILabel!
    @IBOutlet var imageNameTitle: UILabel!
    @IBOutlet var stateImage: UIImageView!

    @IBOutlet var background: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        makeStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func makeStyle() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        background.layer.cornerRadius = 10.0
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.darkGray.cgColor
        background.layer.shadowRadius = 3
        background.layer.shadowOpacity = 0.3
        background.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    func fillCell(with tuple: (name: String, amount: Int)) {
        imageNameTitle.text = tuple.name
        containersAmountLabel.text = String(tuple.amount)
        stateImage.image = UIImage(named: "play")
//        if container.isStarted() {
//            stateImage.image = UIImage(named:"green-circle.png")
//        } else {
//            stateImage.image = UIImage(named:"grey-circle.png")
//        }
    }

}
