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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillCell(with container: Container) {
        nameLabel.text = container.name.value
        imageLabel.text = container.image.value
        statusImage.image = UIImage(named: "play")
    }

}
