//
//  PreferencesViewModel.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 11/09/1446 AH.
//

//import Foundation
//import SwiftUI
//import SwiftData
//import UserNotifications
//
//class PreferencesViewModel: ObservableObject {
//    @Published var startTime: String = "9:00 AM"
//    @Published var endTime: String = "5:00 PM"
//    @Published var notificationFrequency: String = "Once"
//    @Published var isExerciseEnabled: Bool = true
//    @Published var isBreakEnabled: Bool = false
//    @Published var filteredEndTimeOptions: [String] = []
//    
//    let timeOptions = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM",
//                       "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM",
//                       "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM",
//                       "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
//    
//    let notificationOptions = ["Once", "Twice", "Four times"]
//
//    @AppStorage("hasSetPreferences") private var hasSetPreferences = false
//    private var modelContext: ModelContext
//    
//    init(modelContext: ModelContext) {
//        self.modelContext = modelContext
//        loadPreferences()
//    }
//
//    func updateEndTimeOptions() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "h:mm a"
//
//        if let startDate = dateFormatter.date(from: startTime) {
//            filteredEndTimeOptions = timeOptions.filter { timeString in
//                if let timeDate = dateFormatter.date(from: timeString) {
//                    return timeDate > startDate
//                }
//                return false
//            }
//            if let firstAvailableTime = filteredEndTimeOptions.first {
//                endTime = firstAvailableTime
//            }
//        }
//    }
//
//    func savePreferences() {
//        let preferences = UserPreferences(startTime: startTime, endTime: endTime,
//                                          notificationFrequency: notificationFrequency,
//                                          isExerciseEnabled: isExerciseEnabled,
//                                          isBreakEnabled: isBreakEnabled)
//
//        modelContext.insert(preferences)
//        hasSetPreferences = true
//    }
//
//    func loadPreferences() {
//        if let savedPreferences = modelContext.fetch(UserPreferences.self).first {
//            self.startTime = savedPreferences.startTime
//            self.endTime = savedPreferences.endTime
//            self.notificationFrequency = savedPreferences.notificationFrequency
//            self.isExerciseEnabled = savedPreferences.isExerciseEnabled
//            self.isBreakEnabled = savedPreferences.isBreakEnabled
//        }
//    }
//
//    func scheduleNotifications() {
//        NotificationManager.scheduleNotifications(
//            startTime: startTime, endTime: endTime,
//            notificationFrequency: notificationFrequency,
//            isBreakEnabled: isBreakEnabled,
//            isExerciseEnabled: isExerciseEnabled)
//    }
//}
//
