//
//  LogsNumberCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 24/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol ChoiceOfLogsAmountCellDelegate {
    func changeAmountOfLogs(amount: Int)
}

class ChoiceOfLogsAmountCell: UITableViewCell {

    @IBOutlet var amountLabel: UILabel!
    var logsAmount = 0
    var delegate: ChoiceOfLogsAmountCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func fill(with amount: Int) {
        if amount == -1 {
            amountLabel.text = "all"
            return
        }
        logsAmount = amount
        amountLabel.text = String(logsAmount)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
