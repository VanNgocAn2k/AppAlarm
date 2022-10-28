//
//  Day.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 08/10/2022.
//

import Foundation
import RealmSwift

@objc class Alarm: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var time: Date = Date()
    @objc dynamic var labelAlarm: String = ""
    @objc dynamic var repeatAlarm: String = ""
    @objc dynamic var soundAlarm: String = ""
    @objc dynamic var isEnable: Bool
    @objc dynamic var onOffSnoozed: Bool
    
    override init() {
        self.id = UUID().uuidString
        self.soundAlarm = ""
        self.time = Date()
        self.labelAlarm = ""
        self.repeatAlarm = ""
        self.isEnable = false
        self.onOffSnoozed = false
    }
    init(time: Date, labelAlarm: String, repeatAlarm: String, soundAlarm: String, isEnable: Bool, onOffSnoozed: Bool) {
        self.id = UUID().uuidString
        self.soundAlarm = soundAlarm
        self.time = time
        self.labelAlarm = labelAlarm
        self.repeatAlarm = repeatAlarm
        self.isEnable = isEnable
        self.onOffSnoozed = onOffSnoozed
    }
    
}


