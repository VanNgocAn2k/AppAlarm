//
//  EditAlarmViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit
import UserNotifications

protocol deleteDelegste: AnyObject {
    func deleteAlarm(deleteA: Alarm)
}
protocol updateAlarmDelegate: AnyObject {
    func updateAlarm(updateA: Alarm)
}
protocol timelabelRepeatSoundDelegate {
    func setTimeLabelRepeatSoundAlarm(time: Date, labelAlarm: String, repeatAlarm: String, sound: String)
}

class EditAlarmViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    var weekdays: [String] = ["CN", "Thứ 2", "Thứ 3", "Thứ 4", "Thứ 5", "Thứ 6", "Thứ 7"]
    var snoozeEnable = false
    var delegate: timelabelRepeatSoundDelegate?
    var deleteDelegate: deleteDelegste?
    var updateDelegate: updateAlarmDelegate?
    let notificationCenter = UNUserNotificationCenter.current()
    
    var repeats: [Int] = []
    var currentSound: String = ""
    var labelAlarm2 = ""
    var repeatText = ""
    var objectAlarm: Alarm?
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var titleNavi: UINavigationItem!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var labelAlarmLabel: UILabel!
    @IBOutlet weak var soundAlarmLabel: UILabel!
    @IBOutlet weak var deleteAlarmButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let objectAlarm = objectAlarm {
            repeatLabel.text = objectAlarm.repeatAlarm
            labelAlarmLabel.text = objectAlarm.labelAlarm
            soundAlarmLabel.text = objectAlarm.soundAlarm
        }
        // nếu objAlarm khác nil thì ko có nút delete, còn objAlarm bằng nill thì có nút delete
        if objectAlarm != nil {
            deleteAlarmButton.isHidden = false
            titleNavi.title = "Sửa Báo thức"
        } else if objectAlarm == nil {
            deleteAlarmButton.isHidden = true
        }
        configDatePicker()
        
    }
    func configDatePicker() {
        datePicker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        //        datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .clear
        
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(datePicker)
    }
    
    @IBAction func deleteAlarmAction(_ sender: UIButton) {
        print("tap button")
        deleteDelegate?.deleteAlarm(deleteA: objectAlarm!)
        Manager.shared.removeAlarm(alarm: objectAlarm!)
        dismiss(animated: true)
        
    }
    @IBAction func repeatButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "repeatVC", sender: nil)
    }
    
    @IBAction func labelAlarmButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "labelVC", sender: nil)
    }
    
    @IBAction func soundButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "soundVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "labelVC" {
            if let vc = segue.destination as? LabelViewController {
                vc.delegateLabel = self
                
            }
        } else  if segue.identifier == "soundVC" {
            if let vc = segue.destination as? SoundViewController {
                vc.delegate = self
            }
        } else  if segue.identifier == "repeatVC" {
            if let vc = segue.destination as? RepeatViewController {
                vc.delegate = self
            }
        }
        
    }
    
    @IBAction func snoozeSwitchAction(_ sender: UISwitch) {
        snoozeEnable = sender.isOn
    }
    
    @IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        
        let date = self.datePicker.date
        let currentDate = Date()
        let tomorrow = date.addingTimeInterval(24.0 * 3600.0)
        print("Hôm nay", date)
        print("ngay mai", tomorrow)
        let date1 = date.timeIntervalSince1970
        print("date 1", date1)
        let current2 = currentDate.timeIntervalSince1970
        print("current2", current2)
        
        //MARK: Realm
        // new alarm
        // Nếu objAlarm bằng nil thì tạo mới alarm , nếu objectAlarm khác nil thì sửa alarm
        if objectAlarm == nil {
            if repeats.count == 0 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm:  "", sound: currentSound)
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm: "", soundAlarm: currentSound, isEnable: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Chỉ báo 1 lầnweekdaysz
                weekdays
                
                if date1 > current2 {
                    print("hoom nay")
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "Báo thức1"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    //                    notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                    //                        var identifiers: [String] = []
                    //                        for notification: UNNotificationRequest in notificationRequests {
                    //                            if notification.content.userInfo["key"] as? String == "Báo thức1" {
                    //                                identifiers.append(notification.identifier)
                    //                            }
                    //                        }
                    //                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                    //                    }
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                } else if date1 < current2 {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "Báo thức2"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tomorrow)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    //                    notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                    //                        var identifiers: [String] = []
                    //                        for notification: UNNotificationRequest in notificationRequests {
                    //                            if notification.content.userInfo["key"] as? String == "Báo thức" {
                    //                                identifiers.append(notification.identifier)
                    //                            }
                    //                        }
                    //                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                    //                    }
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                }
                
            } else if repeats.count == 7 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày", sound: currentSound)
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày", soundAlarm: currentSound, isEnable: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Lặp lại hàng ngày
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "Báo thức3"]
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                //                notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                //                    var identifiers: [String] = []
                //                    for notification: UNNotificationRequest in notificationRequests {
                //                        if notification.content.userInfo["key"] as? String == "Báo thức" {
                //                            identifiers.append(notification.identifier)
                //                        }
                //                    }
                //                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                //                }
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                
                
            } else {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2, repeatAlarm: ",\(repeatText)", sound: currentSound)
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2, repeatAlarm: ",\(repeatText)", soundAlarm: currentSound, isEnable: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Chỗ này lặp lại các tthứ cụ thể
                let hour: Int = Calendar.current.component(.hour, from: date)
                let minute: Int = Calendar.current.component(.minute, from: date)
                let year: Int = Calendar.current.component(.year, from: date)
                // let weekday: Int = Calendar.current.component(.weekday, from: date)
                var weekday = 1
                for wd in repeats {
                    if wd == 0 {
                        weekday = 1
                        print("thứ", weekday)
                    } else if wd == 1 {
                        weekday = 2
                        print("thứ", weekday)
                    } else if wd == 2 {
                        weekday = 3
                        print("thứ", weekday)
                    }else if wd == 3 {
                        weekday = 4
                        print("thứ", weekday)
                    }else if wd == 4 {
                        weekday = 5
                        print("thứ", weekday)
                    }else if wd == 5 {
                        weekday = 6
                        print("thứ", weekday)
                    }else if wd == 6 {
                        weekday = 7
                        print("thứ", weekday)
                    }
                }
                // lấy cái func nhìn cho gọn
                createDate(weekday: weekday, hour: hour, minute: minute, year: year)
                scheduleNotification(at: date, body: labelAlarm2, titles: "Báo thức")
            }
            // updateAlarm
        } else if objectAlarm != nil {
            
            if repeats.count == 0 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm:  "", sound: currentSound)
                updateDelegate?.updateAlarm(updateA: objectAlarm!)
                Manager.shared.updateAlarm(alarm: objectAlarm!, newTime: date, newRepeat: "", newLabel: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, newSound: currentSound)
                // Chỉ báo 1 lần
                if date1 > current2 {
                    print("hoom nay")
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "Báo thức1"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                        var identifiers: [String] = []
                        for notification: UNNotificationRequest in notificationRequests {
                            if notification.content.userInfo["key"] as? String == "Báo thức1" {
                                identifiers.append(notification.identifier)
                            }
                        }
                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                } else if date1 < current2 {
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "Báo thức2"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: tomorrow)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                        var identifiers: [String] = []
                        for notification: UNNotificationRequest in notificationRequests {
                            if notification.content.userInfo["key"] as? String == "Báo thức2" {
                                identifiers.append(notification.identifier)
                            }
                        }
                        self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                    }
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                }
                
            } else if repeats.count == 7 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày", sound: currentSound)
                updateDelegate?.updateAlarm(updateA: objectAlarm!)
                Manager.shared.updateAlarm(alarm: objectAlarm!, newTime: date, newRepeat: "Hàng ngày", newLabel: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, newSound: currentSound)
                // Lặp lại hàng ngày
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "Báo thức3"]
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification: UNNotificationRequest in notificationRequests {
                        if notification.content.userInfo["key"] as? String == "Báo thức3" {
                            identifiers.append(notification.identifier)
                        }
                    }
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                }
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                
            } else {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2, repeatAlarm: ",\(repeatText)", sound: currentSound)
                updateDelegate?.updateAlarm(updateA: objectAlarm!)
                Manager.shared.updateAlarm(alarm: objectAlarm!, newTime: date, newRepeat: ",\(repeatText)", newLabel: labelAlarm2, newSound: currentSound)
                // Chỗ này lặp lại các tthứ cụ thể
                let hour: Int = Calendar.current.component(.hour, from: date)
                let minute: Int = Calendar.current.component(.minute, from: date)
                let year: Int = Calendar.current.component(.year, from: date)
                var weekday = 0
                
                for wd in repeats {
                    if wd == 0 {
                        weekday = 1
                        print("thứ", weekday)
                    } else if wd == 1 {
                        weekday = 2
                        print("thứ", weekday)
                    } else if wd == 2 {
                        weekday = 3
                        print("thứ", weekday)
                    } else if wd == 3 {
                        weekday = 4
                        print("thứ", weekday)
                    } else if wd == 4 {
                        weekday = 5
                        print("thứ", weekday)
                    } else if wd == 5 {
                        weekday = 6
                        print("thứ", weekday)
                    } else if wd == 6 {
                        weekday = 7
                        print("thứ", weekday)
                    }
                }
                //
                createDate(weekday: weekday, hour: hour, minute: minute, year: year)
                //                   scheduleNotification(at: date, body: labelAlarm2, titles: "Báo thức")
               
                
                let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "Báo thức4"]
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                self.notificationCenter.delegate = self
                notificationCenter.getPendingNotificationRequests { (notificationRequests) in
                    var identifiers: [String] = []
                    for notification: UNNotificationRequest in notificationRequests {
                        if notification.content.userInfo["key"] as? String == "Báo thức4" {
                            identifiers.append(notification.identifier)
                        }
                    }
                    self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
                }
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func createDate(weekday: Int, hour: Int, minute: Int, year: Int) -> Date{
        
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        components.year = year
        components.weekday = weekday // sunday = 1 ... saturday = 7
        components.weekdayOrdinal = 10
        components.timeZone = .current
        
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(from: components)!
    }
    //Schedule Notification with weekly bases.
    func scheduleNotification(at date: Date, body: String, titles:String) {
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute,.second,], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Báo thức"
        content.body = self.labelAlarm2
        content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
        content.userInfo = ["key": "Báo thức4"]
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        self.notificationCenter.delegate = self
        //        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
        //            var identifiers: [String] = []
        //            for notification: UNNotificationRequest in notificationRequests {
        //                if notification.content.userInfo["key"] as? String == "Báo thức" {
        //                    identifiers.append(notification.identifier)
        //                }
        //            }
        //            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        //        }
        self.notificationCenter.add(request) { (error) in
            if (error != nil) {
                print("Error" + error.debugDescription)
                return
            }
        }
    }
    
}

extension EditAlarmViewController: PassLabelDelegate, PassSoundAlarmDelegate, RepeatViewControllerdelgate {
    
    func pickRepeat(repeats: [Int]) {
        
        let string = repeats.map { weekdays[$0] }.joined(separator: " ")
        if repeats.count == 0 {
            repeatLabel.text = "Không"
        } else if repeats.count == 7 {
            repeatLabel.text = "Hàng ngày"
        } else {
            repeatLabel.text = string
        }
        self.repeatText = string
        self.repeats = repeats
    }
    
    func updateLabelAlarm(labelAlarm: String) {
        labelAlarmLabel.text = labelAlarm
        self.labelAlarm2 = labelAlarm
    }
    func updateSuond(sound: String) {
        soundAlarmLabel.text = sound
        self.currentSound = sound
    }
}
