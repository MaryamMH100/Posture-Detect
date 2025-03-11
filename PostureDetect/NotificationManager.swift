//
//  NotificationManager.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 11/09/1446 AH.
//

import Foundation
import UserNotifications

class NotificationManager {
    static func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }

    static func scheduleNotifications(startTime: String, endTime: String,
                                      notificationFrequency: String,
                                      isBreakEnabled: Bool, isExerciseEnabled: Bool) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        guard let startDate = dateFormatter.date(from: startTime),
              let endDate = dateFormatter.date(from: endTime) else {
            print("Invalid time format.")
            return
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        let frequencyCount: Int
        switch notificationFrequency {
        case "Once": frequencyCount = 1
        case "Twice": frequencyCount = 2
        case "Four times": frequencyCount = 4
        default: frequencyCount = 1
        }
        
        let interval = duration / Double(frequencyCount)
        
        for i in 0..<frequencyCount {
            let notificationTime = startDate.addingTimeInterval(interval * Double(i))
            scheduleSingleNotification(title: "Reminder", body: "Check your posture!", time: notificationTime, center: center)
        }
        
        if isBreakEnabled {
            scheduleSingleNotification(title: "Break", body: "Time for a break!", time: startDate, center: center)
        }
        
        if isExerciseEnabled {
            scheduleSingleNotification(title: "Exercise", body: "Time for some exercise!", time: startDate, center: center)
        }
    }

    private static func scheduleSingleNotification(title: String, body: String, time: Date, center: UNUserNotificationCenter) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour, .minute], from: time), repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print("Error scheduling \(title) notification: \(error.localizedDescription)")
            }
        }
    }
}
