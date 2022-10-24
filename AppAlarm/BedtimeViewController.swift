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
//    public struct NotificationManager {
//        let notificationCenter = UNUserNotificationCenter.current()
//        static let sharedInstance = NotificationManager()
//
//       private func checkRequestAuthorization(completion: @escaping(Bool) -> Void) -> () {
//            let options: UNAuthorizationOptions = [.alert, .sound,]
//            notificationCenter.requestAuthorization(options: options) {
//                (didAllow, error) in
//                completion(didAllow)
//            }
//        }
//
//        func setLocalNotifications() {
//            checkRequestAuthorization { isAllowed in
//                if isAllowed {
//                    let credentials = getNotificationsCredentials()
//                    addNotificationRequest(title: Localizables.InformationTitles.notificationTitle, body: Localizables.InformationTexts.notificationBody, notifications: credentials)
//                }
//            }
//        }
//
//        private func getNotificationsCredentials() -> [CustomNotification] {
//            return [
//                CustomNotification(hours: 8, title: "Smiling Sunday", body: "What makes you smile?", weekDay: 1),
//                CustomNotification(hours: 16, title: "Self Sunday", body: "Let’s take some time to draw today!", weekDay: 1),
//                CustomNotification(hours: 16, title: "Mindful Monday", body: "Let’s tinker today!",weekDay: 2),
//                CustomNotification(hours: 16, title: "Thoughtful Tuesday", body: "Come and play!",weekDay: 3),
//                CustomNotification(hours: 16, title: "Wishful Wednesday", body: "Let’s make a wish today!",weekDay: 4),
//                CustomNotification(hours: 16, title: "Thankful Thursday", body: "What are you thankful for today?",weekDay: 5),
//                CustomNotification(hours: 16, title: "Feeling Friday,", body: "Let’s explore our feelings together!",weekDay: 6),
//                CustomNotification(hours: 8, title: "Super Saturday", body: "What are you super excited for today?",weekDay: 7),
//                CustomNotification(hours: 16, title: "Singing Saturday,", body: "Let’s dance and sing together!",weekDay: 7),
//            ]
//        }
//
//        private func addNotificationRequest(title: String, body: String, notifications: [CustomNotification]) {
//            notificationCenter.removeAllPendingNotificationRequests()
//           // let gregorian = Calendar(identifier: Calendar.Identifier.gregorian)
//          //  let now = Date()
//            for notification in notifications {
//                let content = UNMutableNotificationContent()
//                content.title = notification.title
//                content.body = notification.body
//                content.sound = UNNotificationSound.default
//                var dateComponents = DateComponents()
//                dateComponents.timeZone = TimeZone.current
//                dateComponents.hour = notification.hours
//                dateComponents.minute = 10
//                dateComponents.second = 00
//                dateComponents.weekday = notification.weekDay
//                //let date = gregorian.date(from: dateComponents);
//                let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//
//                let formatter = DateFormatter();
//                formatter.dateFormat = "MM-dd-yyyy HH:mm";
//                let dailyTrigger = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!);
//                let trigger = UNCalendarNotificationTrigger(dateMatching: dailyTrigger, repeats: true);
//                let identifier = UUID().uuidString
//                let reguest = UNNotificationRequest(identifier: identifier, content: content, trigger: notificationTrigger)
//                notificationCenter.add(reguest) { err in
//                }
//            }
//
//        }
//    }
//

}
