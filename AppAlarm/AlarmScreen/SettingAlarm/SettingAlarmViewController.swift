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
        
        if arrData.count == 0 {
//            if #available(iOS 16.0, *) {
//                self.editAlarm.isHidden = true
//            } else {
//                // Fallback on earlier versions
//            }
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black
        cell.selectedBackgroundView = backgroundView
        return cell
        
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteButton = UIContextualAction(style: .destructive, title: "Xoá") { _, _, _ in
            // xóa phần tử tại indexPath.row
            let deleteAlarm = self.arrData[indexPath.row]
            Manager.shared.removeAlarm(alarm: deleteAlarm)
            self.fetchData()
          
        }
        deleteButton.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        // Vuốt sang trái để xoá
//        return .delete
//    }
    
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
        if isEditing {
            self.index = indexPath
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditAlarmViewController") as! EditAlarmViewController
            vc.objectAlarm = arrData[indexPath.row]
            vc.deleteDelegate = self
            vc.updateDelegate = self
            self.present(vc, animated: true)
             }        
//            self.index = indexPath
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "EditAlarmViewController") as! EditAlarmViewController
//            vc.objectAlarm = arrData[indexPath.row]
//            vc.deleteDelegate = self
//            vc.updateDelegate = self
//            self.present(vc, animated: true)
//        }

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
        let timeLabelRepeat2 = Alarm(time: time, labelAlarm: labelAlarm, repeatAlarm: repeatAlarm, soundAlarm: sound, isEnable: true)
        print(timeLabelRepeat2)
        arrData.append(timeLabelRepeat2)
        self.alarmTableView.reloadData()
    }
}
