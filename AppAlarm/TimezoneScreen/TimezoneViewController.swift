//
//  TimezoneViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 07/10/2022.
//

import UIKit

class TimezoneViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editTimeZone: UIBarButtonItem!
    var arrCity: [String] = []
    var isEditMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editTimeZone.title = "Sửa"

        let timeCell = UINib(nibName: "TimezoneTableViewCell", bundle: nil)
        self.tableView.register(timeCell, forCellReuseIdentifier: "TimezoneTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .gray
        tableView.tableFooterView = UIView()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEdit))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
   @objc func endEdit() {
        tableView.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        arrCity = getUserDefault()
    }
    @IBAction func editAction(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
        if isEditMode {
            self.isEditMode = false
            self.editTimeZone.title = "Sửa"
        } else {
            self.isEditMode = true
            self.editTimeZone.title = "Xong"
        }
        self.setEditing(isEditMode, animated: true)
    }
    
    @IBAction func addTimezoneAction(_ sender: Any) {
        self.performSegue(withIdentifier: "addTimezoneVC", sender: nil)
        
    }
}
extension TimezoneViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCity.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimezoneTableViewCell", for: indexPath) as! TimezoneTableViewCell
        cell.timeZoneLabel.text = arrCity[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            arrCity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            setUserDefault()
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
//     Di chuyển cell
       let affectedEvent = arrCity[fromIndexPath.row]
            arrCity.remove(at: fromIndexPath.row)
            arrCity.insert(affectedEvent, at: toIndexPath.row)
        tableView.reloadData()
        setUserDefault()
    }

}
extension TimezoneViewController: WorldClockDelegate {
    func addTimeZone(timeZone: String) {
        arrCity.append(timeZone)
        tableView.reloadData()
        setUserDefault()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTimezoneVC" {
            let destination = segue.destination as! AddTimezoneViewController
            destination.delegate = self
        }
    }
    // User default
    func setUserDefault() {
        UserDefaults.standard.set(arrCity, forKey: "WorldClocks")
        UserDefaults.standard.synchronize()
    }
    func getUserDefault() -> [String] {
        if UserDefaults.standard.value(forKey: "WorldClocks") != nil {
            arrCity = UserDefaults.standard.value(forKey: "WorldClocks") as! [String]
        }
       return arrCity
    }
    
}
