//
//  ContainerTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 29/10/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

class ContainerTableCell: UITableViewCell {
   
    @IBOutlet weak var containerNameLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var stateImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func fillCell(with container: Container) {
        self.containerNameLabel.text = container.firstName
        if container.isStarted() {
            stateImage.image = UIImage(named:"green-circle.png")
        } else {
            stateImage.image = UIImage(named:"grey-circle.png")
        }
        self.imageLabel.text = container.image
    }

    
}
