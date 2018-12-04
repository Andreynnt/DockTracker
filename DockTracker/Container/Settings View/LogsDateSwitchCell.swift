//
//  LogsDateTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 24/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol LogsDateSwitchCellDelegate {
    func changeNeedLogs(need: Bool)
}

class LogsDateSwitchCell: UITableViewCell {
    
    @IBOutlet var dateSwitch: UISwitch!
    var needDate = false
    var delegate: LogsDateSwitchCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateSwitch.isOn = false
    }
    
    @IBAction func clickOnSwitch(_ sender: Any) {
       needDate = !needDate
       delegate?.changeNeedLogs(need: needDate)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
