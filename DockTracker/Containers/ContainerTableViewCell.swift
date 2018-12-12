//
//  ContainerTableViewCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 10/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerTableViewCell: UITableViewCell {

    @IBOutlet var statusImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imageLabel: UILabel!
    @IBOutlet var backgroundCard: UIView!
    @IBOutlet var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        makeStyle()
    }

    func makeStyle() {
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        backgroundCard.layer.cornerRadius = 10.0
        backgroundCard.layer.masksToBounds = false
        backgroundCard.layer.shadowColor = UIColor.darkGray.cgColor
        backgroundCard.layer.shadowRadius = 3
        backgroundCard.layer.shadowOpacity = 0.3
        backgroundCard.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func fillCell(with container: Container) {
        nameLabel.text = container.name.value
        imageLabel.text = container.image.value
        //statusImage.image = UIImage(named: "play")
        let parsedStatus = parseStatus(container.status.value)
        timeLabel.text = parsedStatus
    }

    func parseStatus(_ status: String) -> String {
        if status.range(of: "Exited") != nil {
            let startIndex = status.index(of: ")")!
            let i = status.index(startIndex, offsetBy: 1)
            return String(status[i...])
        }
        return status
    }

}
