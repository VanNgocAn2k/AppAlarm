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
    var currentSound = ""
    var labelAlarm2 = ""
    var repeatText = ""
    var objectAlarm: Alarm?
    let datePicker = UIDatePicker()
    
    
    @IBOutlet weak var titleNavi: UINavigationItem!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var labelAlarmLabel: UILabel!
    @IBOutlet weak var soundAlarmLabel: UILabel!
    @IBOutlet weak var deleteAlarmButton: UIButton!
    @IBOutlet weak var stateSwitch: UISwitch!
    
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
        view.addSubview(datePicker)
        datePicker.frame = CGRect(x: 0, y: 50, width: self.view.frame.width, height: 200)
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        datePicker.datePickerMode = .time
        datePicker.backgroundColor = .clear
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
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
        if objectAlarm == nil {
            if stateSwitch.isOn == true {
                objectAlarm?.onOffSnoozed = true
//                removePendingNotification()
                snoozeAddNotifi()
                print("switch on")
            } else {
                removePendingNotification()
                print("switch off")
            }
        } else if objectAlarm != nil {
//            if sender.isOn {
//                objectAlarm!.onOffSnoozed = false
////                removePendingNotification()
////                var date2 = objectAlarm!.time
////                print("date2", date2)
////                snoozeAddNotifi()
//                print("switch on")
//            } else {
//                print("switch off")
//            }
            if objectAlarm!.onOffSnoozed == true {
                sender.isOn = true
                snoozeAddNotifi()
                print("on")
            } else {
                removePendingNotification()
                print("off")
            }
        }
    }
    
    @IBAction func dismissButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: UIBarButtonItem) {
        
        let date = self.datePicker.date
        let currentDate = Date()
        let tomorrow = date.addingTimeInterval(24.0 * 3600.0)
        //        let tomorrow2 = Calendar.current.date(byAdding: .day, value: 1, to: date)
        print("Hôm nay", date)
        print("ngay mai", tomorrow)
        //        print("ngay mai 2", tomorrow2)
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
                
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm: "", soundAlarm: currentSound, isEnable: true, onOffSnoozed: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Chỉ báo 1 lầnweekdaysz
                if date1 > current2 {
                    print("hoom nay")
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "\(newAlarm.id)"]
                    
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: newAlarm.id , content: content, trigger: trigger)
                    print("AlarmId", newAlarm.id)
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
                    content.userInfo = ["key": "\(newAlarm.id)"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrow)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: newAlarm.id, content: content, trigger: trigger)
                    self.notificationCenter.add(request) { (error) in
                        if (error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                    }
                }
                
            } else if repeats.count == 7 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày", sound: currentSound)
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2.count > 0 ? "\(labelAlarm2), " : labelAlarm2, repeatAlarm: "Hàng ngày", soundAlarm: currentSound, isEnable: true, onOffSnoozed: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Lặp lại hàng ngày
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "\(newAlarm.id)"]
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let request = UNNotificationRequest(identifier: newAlarm.id, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                
                
            } else {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức," : labelAlarm2, repeatAlarm: repeatText, sound: currentSound)
                let newAlarm = Alarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức," : labelAlarm2, repeatAlarm: repeatText, soundAlarm: currentSound, isEnable: true, onOffSnoozed: true)
                Manager.shared.addNewAlarm(alarm: newAlarm)
                // Chỗ này lặp lại các tthứ cụ thể
                let hour: Int = Calendar.current.component(.hour, from: date)
                print("Giờ chọn được", hour)
                let minute: Int = Calendar.current.component(.minute, from: date)
                print("phút", minute)
                let year: Int = Calendar.current.component(.year, from: date)
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
                
                let dateNew = createDate(weekday: weekday, hour: hour, minute: minute, year: year)
                print("dateNew", dateNew)
                //                scheduleNotification(at: dateNew, body: labelAlarm2, titles: "Báo thức")
                
                let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: dateNew)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "\(newAlarm.id)"]
                let request = UNNotificationRequest(identifier: newAlarm.id, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
            }
            // Nếu có giá trị thì updateAlarm
        } else if objectAlarm != nil {
            
            if repeats.count == 0 {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, repeatAlarm:  "", sound: currentSound)
                updateDelegate?.updateAlarm(updateA: objectAlarm!)
                Manager.shared.updateAlarm(alarm: objectAlarm!, newTime: date, newRepeat: "Không", newLabel: labelAlarm2.count == 0 ? "Báo thức" : labelAlarm2, newSound: currentSound)
                // Chỉ báo 1 lần
                if date1 > current2 {
                    print("hoom nay")
                    let content = UNMutableNotificationContent()
                    content.title = "Báo thức"
                    content.body = self.labelAlarm2
                    content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                    content.userInfo = ["key": "\(objectAlarm!.id)"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: objectAlarm!.id, content: content, trigger: trigger)
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
                    content.userInfo = ["key": "\(objectAlarm!.id)"]
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: tomorrow)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                    let request = UNNotificationRequest(identifier: objectAlarm!.id, content: content, trigger: trigger)
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
                content.userInfo = ["key": "\(objectAlarm!.id)"]
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                let request = UNNotificationRequest(identifier: objectAlarm!.id, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                
            } else {
                delegate?.setTimeLabelRepeatSoundAlarm(time: date, labelAlarm: labelAlarm2.count == 0 ? "Báo thức," : labelAlarm2, repeatAlarm: repeatText, sound: currentSound)
                updateDelegate?.updateAlarm(updateA: objectAlarm!)
                Manager.shared.updateAlarm(alarm: objectAlarm!, newTime: date, newRepeat: repeatText, newLabel: labelAlarm2.count == 0 ? "Báo thức," : labelAlarm2, newSound: currentSound)
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
                
                let dateNew = createDate(weekday: weekday, hour: hour, minute: minute, year: year)
                //                   scheduleNotification(at: date, body: labelAlarm2, titles: "Báo thức")
                let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: dateNew)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "Báo thức"
                content.body = self.labelAlarm2
                content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
                content.userInfo = ["key": "\(objectAlarm!.id)"]
                
                let request = UNNotificationRequest(identifier: objectAlarm!.id, content: content, trigger: trigger)
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
    func snoozeAddNotifi() {
        let date = self.datePicker.date
        print("giờ hiện tại", date)
        let snoozeDate = date.addingTimeInterval(60)
        print("giờ cộng thêm", snoozeDate)
        let content = UNMutableNotificationContent()
        content.title = "Báo lại"
        content.body = self.labelAlarm2
        content.sound = UNNotificationSound(named: UNNotificationSoundName(self.currentSound + ".mp3"))
        content.userInfo = ["key":"id1"]
        let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: snoozeDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        //                removePendingNotification()
        self.notificationCenter.add(request) { (error) in
            if (error != nil) {
                print("Error" + error.debugDescription)
                return
            }
        }
    }
    func removePendingNotification() {
        notificationCenter.getPendingNotificationRequests { (notificationRequests) in
            var identifiers: [String] = []
            for notification: UNNotificationRequest in notificationRequests {
                if notification.content.userInfo["key"] as? String == "id1" {
                    identifiers.append(notification.identifier)
                }
            }
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
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
