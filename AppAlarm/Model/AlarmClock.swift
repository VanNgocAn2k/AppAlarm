//
//  AlarmClock.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import Foundation
import UIKit

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
//                else {
                    
//                    let hour: Int = Calendar.current.component(.hour, from: date)
//                    let minute: Int = Calendar.current.component(.minute, from: date)
//                    let year: Int = Calendar.current.component(.year, from: date)
//                    var weekday = 0
//                    let arrString = repeatAlarm.components(separatedBy: " ")
//                    let someDic = ["CN":1, "Thứ 2":2, "Thứ 3":3, "Thứ 4":4, "Thứ 5":5, "Thứ 6":6, "Thứ 7":7]
//                    print(someDic["CN"])
//                    //                    for (key, value) in someDic {
//                    //                   //if key == repeatAlarm && value == weekday {
//                    //                   //weekday = value
//                    //                   // print("key:\(key) Thứ:\(value)")
//                    //                   //}
//                    //
//                    //                        repeatAlarm = key
//                    //                        weekday = value
//                    //                        print("key:\(key) Thứ:\(value)")
//                    //                    }
//
//                    var arrInt = [Int]()
//                    for i in arrString {
//                        print(i)
////                        arrInt.append(someDic[i])
//                    }
//
//                    print("asdadadadadad", arrInt)
//                    // Đây mới là 1 mảng string này
//                    let b = ["Thứ 2", "Thứ 3"]
//                    for i in repeatAlarm {
//                        let a = i
//                        print(a)
//                    }
//
////                    for r in repeatAlarm {
////                        let weekday = someDic[r] // => int
////                       print("abc", weekday)
////
////                    }
////                    for wd in repeatAlarm {
////                        if wd == 0 {
////                            weekday = 1
////                            print("thứ", weekday)
////                        } else if wd == "Thứ 2" {
////                            weekday = 2
////                            print("thứ", weekday)
////                        } else if wd == "Thứ 3" {
////                            weekday = 3
////                            print("thứ", weekday)
////                        }else if wd == "Thứ 4" {
////                            weekday = 4
////                            print("thứ", weekday)
////                        }else if wd == "Thứ 5" {
////                            weekday = 5
////                            print("thứ", weekday)
////                        }else if wd == "Thứ 6 " {
////                            weekday = 6
////                            print("thứ", weekday)
////                        }else if wd == "Thứ 7 " {
////                            weekday = 7
////                            print("thứ", weekday)
////                        }
////                    }
//
//                    let dateNew = createDate(weekday: weekday, hour: hour, minute: minute, year: year)
//                    print("dateNew", dateNew)
//                    let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: dateNew)
//                    let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)
//                    let content = UNMutableNotificationContent()
//                    content.title = "Báo thức"
//                    content.body = object.labelAlarm
//                    content.sound = UNNotificationSound(named: UNNotificationSoundName(object.soundAlarm + ".mp3"))
//                    content.userInfo = ["key": "\(object.id)"]
//                    let request = UNNotificationRequest(identifier: object.id, content: content, trigger: trigger)
//                    UNUserNotificationCenter.current().add(request) { (error) in
//                        if (error != nil) {
//                            print("Error" + error.debugDescription)
//                            return
//                        }
//                    }
//                }
