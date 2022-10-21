//
//  CustomTableViewCell.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var labelRepeatAlarmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var alarmSwitchLabel: UISwitch!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        alarmSwitchLabel.isHidden = true
    }
    
    @IBAction func onOffAlarmSwitch(_ sender: UISwitch) {
        if sender.isOn {
            labelRepeatAlarmLabel.textColor = .white
            timeLabel.textColor = .white
        } else {
            labelRepeatAlarmLabel.textColor = .gray
            timeLabel.textColor = .gray
        }
    }
}
