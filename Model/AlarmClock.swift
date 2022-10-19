//
//  AlarmClock.swift
//  AppAlarm
//
//  Created by Van Ngoc An  on 24/09/2022.
//

import Foundation
import UIKit

//struct AlarmClock{
//    var time: String
//    var labelAlarm: String
//    var repeatAlarm: String
//    var isEnable: Bool
//}

protocol AlarmSchedulerDelegate {
    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify:[Int], snoozeEnabled: Bool, onSnooze:Bool, soundName: String, index: Int)
    //helper
    func setNotificationForSnooze(snoozeMinute: Int, soundName: String, index: Int)
    func setupNotificationSettings() -> UIUserNotificationSettings
    func reSchedule()
    func checkNotification()
}
func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
    let second = calendar.component(.second, from: date)
    let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
    return d
}
enum weekdaysComparisonResult {
    case before
    case same
    case after
}

func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
{
    if w1 != 1 && w2 == 1 {return .before}
    else if w1 == w2 {return .same}
    else {return .after}
}
func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
{
    var correctedDate: [Date] = [Date]()
    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    let now = Date()
    let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
    let dateComponents = (calendar as NSCalendar).components(flags, from: date)
    let weekday:Int = dateComponents.weekday!
    
    //no repeat
    if weekdays.isEmpty{
        //scheduling date is eariler than current date
        if date < now {
            //plus one day, otherwise the notification will be fired righton
            correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
        }
        else { //later
            correctedDate.append(date)
        }
        return correctedDate
    }
    //repeat
    else {
        let daysInWeek = 7
        correctedDate.removeAll(keepingCapacity: true)
        for wd in weekdays {
            
            var wdDate: Date!
            //schedule on next week
            if compare(weekday: wd, with: weekday) == .before {
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
            }
            //schedule on today or next week
            else if compare(weekday: wd, with: weekday) == .same {
                //scheduling date is eariler than current date, then schedule on next week
                if date.compare(now) == ComparisonResult.orderedAscending {
                    wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                }
                else { //later
                    wdDate = date
                }
            }
            //schedule on next days of this week
            else { //after
                wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
            }
            
            //fix second component to 0
            wdDate = correctSecondComponent(date: wdDate, calendar: calendar)
            correctedDate.append(wdDate)
        }
        return correctedDate
    }
}

