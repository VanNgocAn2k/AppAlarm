//
//  SettingAlarmViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import UIKit


class SettingAlarmViewController: UIViewController {
    
    var arrData = [Alarm]()
    var index: IndexPath?
    var isEditingMode = false
    
    @IBOutlet weak var alarmTableView: UITableView!
    @IBOutlet weak var editAlarm: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editAlarm.action = #selector(self.editBarButtonAction(_:))
        self.editAlarm.title = "Sửa"
        self.setEditing(isEditingMode, animated: true)
        // ẩn row chống
        alarmTableView.tableFooterView = UIView()
        // chỉnh màu đường kẻ ngăn cách
        alarmTableView.separatorColor = .gray
        self.alarmTableView.dataSource = self
        self.alarmTableView.delegate = self
        // Cho phép chỉnh sửa chọn các row tableView
        self.alarmTableView.allowsSelectionDuringEditing = true
        
        self.registerTableViewCells()
        fetchData()
    }
    
    func fetchData() {
        arrData = Manager.shared.getAllAlarm()
        alarmTableView.reloadData()
    }
    
    @IBAction func editBarButtonAction(_ sender: UIBarButtonItem) {
        alarmTableView.isEditing = !alarmTableView.isEditing
        if isEditingMode
        {
            isEditingMode = false
            self.editAlarm.title = "Sửa"
    
        }
        else
        {
            isEditingMode = true
            self.editAlarm.title = "Xong"

        }
        self.setEditing(isEditingMode, animated: true)
    }
    
    //MARK: - add new alarm clock
    @IBAction func addBarButtonAction(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showVC", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showVC" {
            if let vc = segue.destination as? EditAlarmViewController {
                vc.delegate = self
            }
        }
    }
    private func registerTableViewCells(){
        let alarmCell = UINib(nibName: "CustomTableViewCell", bundle: nil)
        self.alarmTableView.register(alarmCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    func formattedDate(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
extension SettingAlarmViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        let object = arrData[indexPath.row]
        let date = object.time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: date)
        
        cell.timeLabel.text = "\(time)"
        cell.labelRepeatAlarmLabel.text = "\(object.labelAlarm) \(object.repeatAlarm)"
        
        cell.callBackSwitchState = { sender in
            if sender == true {
                cell.labelRepeatAlarmLabel.textColor = .white
                cell.timeLabel.textColor = .white
                
                // Cần thêm lại thông báo khi bật Switch
                let repeatAlarm = object.repeatAlarm
                print("repeatAlarm", repeatAlarm)
                let date = object.time
                print("date", date)
//                let currentDate = Date()
                let content = UNMutableNotificationContent()
                content.title = "báo thức"
                content.body = object.labelAlarm
                content.sound = UNNotificationSound(named: UNNotificationSoundName(object.soundAlarm + ".mp3"))
                content.userInfo = ["key": "\(object.id)"]
                let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                let request = UNNotificationRequest(identifier: object.id, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { (error) in
                    if (error != nil) {
                        print("Error" + error.debugDescription)
                        return
                    }
                }
                print("On")
            } else {
                cell.labelRepeatAlarmLabel.textColor = .gray
                cell.timeLabel.textColor = .gray
                var idetifirer = [String]()
                idetifirer.append(object.id)
                print("id", idetifirer)
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idetifirer)
//                UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//                Manager.shared.removeAlarm(alarm: object)
                print("Off")
            }
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Xoá") { [weak self] _, _, _ in
            // xóa phần tử tại indexPath.row
            let deleteAlarm = self!.arrData[indexPath.row]
            var identifiers = [String]()
            identifiers.append(deleteAlarm.id)
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            Manager.shared.removeAlarm(alarm: deleteAlarm)
//            Manager.shared.removeAllAlarm(alarm: deleteAlarm)
            self?.fetchData()
        }
        deleteButton.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Khi bấm vào Edit
        if editingStyle == .delete{
            arrData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        // Di chuyển các Row
        let affectedEvent = arrData[fromIndexPath.row]
        arrData.remove(at: fromIndexPath.row)
        arrData.insert(affectedEvent, at: toIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // hàm này dùng để bỏ màu của dòng chọn
        tableView.deselectRow(at: indexPath, animated: false)
        if isEditingMode {
//            tableView.deselectRow(at: indexPath, animated: false)
//            let backgroundView = UIView()
//            backgroundView.backgroundColor = UIColor.black
//            tableView.selectedBackgroundView = backgroundView
            self.index = indexPath
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditAlarmViewController") as! EditAlarmViewController
            vc.objectAlarm = arrData[indexPath.row]
            vc.deleteDelegate = self
            vc.updateDelegate = self
            self.present(vc, animated: true)
        }
    }
}
extension SettingAlarmViewController: timelabelRepeatSoundDelegate, deleteDelegste, updateAlarmDelegate {
    
    func updateAlarm(updateA: Alarm) {
        if index != nil {
            alarmTableView.reloadData()
        }
    }
    
    func deleteAlarm(deleteA: Alarm) {
        if let index = index {
            arrData.remove(at: index.row)
            alarmTableView.reloadData()
        }
    }
    
    func setTimeLabelRepeatSoundAlarm(time: Date, labelAlarm: String, repeatAlarm: String, sound: String) {
        let timeLabelRepeat2 = Alarm(time: time, labelAlarm: labelAlarm, repeatAlarm: repeatAlarm, soundAlarm: sound, isEnable: true, onOffSnoozed: true)
        arrData.append(timeLabelRepeat2)
        self.alarmTableView.reloadData()
    }
}
