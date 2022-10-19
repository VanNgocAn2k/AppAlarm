//
//  BedtimeViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 07/10/2022.
//

import UIKit

class BedtimeViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .time
        if #available(iOS 14.0, *) {
             datePicker.preferredDatePickerStyle = .wheels
        }
    
    }
 

}
