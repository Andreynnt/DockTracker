//
//  LogsDateTableCell.swift
//  DockTracker
//
//  Created by Андрей Бабков on 24/11/2018.
//  Copyright © 2018 Андрей Бабков. All rights reserved.
//

import UIKit

protocol LogsDateSwitchCellDelegate: class {
    func changeNeedLogs(need: Bool)
}

class LogsDateSwitchCell: UITableViewCell {

    @IBOutlet weak var dateSwitch: UISwitch!

    var needDate = false
    weak var delegate: LogsDateSwitchCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        dateSwitch.isOn = false
    }
    @IBAction func clickSwitch(_ sender: UISwitch) {
        needDate = !needDate
        delegate?.changeNeedLogs(need: needDate)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
