//
//  RepeatViewController.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 04/10/2022.
//

import UIKit

protocol RepeatViewControllerdelgate: AnyObject {
    func pickRepeat(repeats: [Int])
}
class RepeatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: RepeatViewControllerdelgate?
    var arrWeekday: [String] = ["Mọi chủ nhật", "Mọi thứ hai", "Mọi thứ ba", "Mọi thứ tư", "Mọi thứ năm", "Mọi thứ sáu", "Mọi thứ bảy"]
    var showImageIndex = Set<Int>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.registerTableViewCells()
    }
    override func viewWillAppear(_ animated: Bool) {
        arrWeekday = getUserDefault()
    }
    private func registerTableViewCells(){
        let repeatCell = UINib(nibName: "RepeatTableViewCell", bundle: nil)
        self.tableView.register(repeatCell, forCellReuseIdentifier: "RepeatTableViewCell")
    }
    func setUserDefault() {
        UserDefaults.standard.set(self.arrWeekday, forKey: "choseCheckmark")
        UserDefaults.standard.synchronize()
    }
    func getUserDefault() -> [String] {
        if UserDefaults.standard.value(forKey: "choseCheckmark") != nil {
            self.arrWeekday = UserDefaults.standard.value(forKey: "choseCheckmark") as! [String]
        }
        return arrWeekday
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        print(showImageIndex)
        //Biến  Set thành Array, và sắp xếp theo tăng dần bằng sorted
        let arry = Array(showImageIndex).sorted()
        print(arry)
        delegate?.pickRepeat(repeats: arry)
        dismiss(animated: true)
    }
}
extension RepeatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrWeekday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepeatTableViewCell", for: indexPath) as! RepeatTableViewCell
        cell.repeatDayLabel.text = arrWeekday[indexPath.row]
        
        if showImageIndex.contains(indexPath.row) {
            cell.checkmarkImage.isHidden = false
        } else {
            cell.checkmarkImage.isHidden = true
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let index = indexPath.row
        
        if showImageIndex.contains(index){
            showImageIndex.remove(index)
        } else {
            showImageIndex.insert(index)
        }
        self.tableView.reloadData()
       
    }
    
    
}
