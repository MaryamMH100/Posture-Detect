//
//  PreferencesView.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 06/09/1446 AH.
//

import Foundation
import SwiftUI
import SwiftData
import UserNotifications

struct PreferencesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    @State private var startTime = "9:00 AM"
    @State private var endTime = "5:00 PM"
    @State private var notificationFrequency = "Once"
    @State private var isExerciseEnabled = true
    @State private var isBreakEnabled = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isFirstTime = true
    @State private var navigateToHomeView = false // متغير للتحكم في الانتقال إلى HomeView

    let timeOptions = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    
    let notificationOptions = ["Once", "Twice", "Four times"]

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { presentationMode.wrappedValue.dismiss() }

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Preferences").font(.largeTitle).bold()
                    Spacer()
                    if isFirstTime {
                        Button("Skip") {
                            hasCompletedOnboarding = true
                            navigateToHomeView = true // الانتقال إلى HomeView دون حفظ الإعدادات
                        }
                        .foregroundColor(Color(red: 0.3, green: 0.44, blue: 0.27))
                        .padding(8)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
//                    if else
//                        Button(System image:"x.circle.fill"){
//                        hasCompletedOnboarding = fales
//                        navigateToHome = true
//
//
//                    }
                        
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Session").font(.headline).bold()

                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .frame(height: 120)
                        .overlay(
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Work hours")
                                    Spacer()
                                    Picker("Start", selection: $startTime) {
                                        ForEach(timeOptions, id: \.self) { time in
                                            Text(time)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 130)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)

                                    Picker("End", selection: $endTime) {
                                        ForEach(timeOptions.filter { $0 > startTime }, id: \.self) { time in
                                            Text(time)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 130)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                }

                                HStack {
                                    Text("Notifications frequency")
                                    Spacer()
                                    Picker("", selection: $notificationFrequency) {
                                        ForEach(notificationOptions, id: \.self) { option in
                                            Text(option)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 120)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
                                }
                            }
                            .padding()
                        )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("General").font(.headline).bold()
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        .frame(height: 120)
                        .overlay(
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Exercise")
                                    Spacer()
                                    CustomToggle(isOn: $isExerciseEnabled, activeColor: Color(red: 0.3, green: 0.44, blue: 0.27))
                                }

                                HStack {
                                    Text("Break")
                                    Spacer()
                                    CustomToggle(isOn: $isBreakEnabled, activeColor: Color(red: 0.3, green: 0.44, blue: 0.27))
                                }
                            }
                            .padding()
                        )
                }

                Button(action: {
                    savePreferences()
                    scheduleNotifications()
                    navigateToHomeView = true // الانتقال إلى HomeView بعد حفظ الإعدادات
                }) {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.3, green: 0.44, blue: 0.27), Color(red: 0.2, green: 0.34, blue: 0.17)]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .onTapGesture {}
                }
                .padding(.horizontal, 40)
                .background(
                    NavigationLink(destination: HomeView(), isActive: $navigateToHomeView) {
                        EmptyView()
                    }
                )
            }
            .padding()
            .frame(width: 500, height: 500)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        }
     
     .onAppear(perform: loadPreferences)
     .onAppear {
         requestNotificationPermission()
     }
     .onDisappear {
         savePreferences() // حفظ التغييرات عند مغادرة الصفحة
     }
 }
    

    private func savePreferences() {
        if !navigateToHomeView || !isFirstTime {
            if let existingPreferences = preferences.first {
                existingPreferences.startTime = startTime
                existingPreferences.endTime = endTime
                existingPreferences.notificationFrequency = notificationFrequency
                existingPreferences.isExerciseEnabled = isExerciseEnabled
                existingPreferences.isBreakEnabled = isBreakEnabled
            } else {
                let newPreferences = UserPreferences(
                    startTime: startTime,
                    endTime: endTime,
                    notificationFrequency: notificationFrequency,
                    isExerciseEnabled: isExerciseEnabled,
                    isBreakEnabled: isBreakEnabled
                )
                modelContext.insert(newPreferences)
            }

            hasCompletedOnboarding = true
            isFirstTime = false
            
            // حفظ الإعدادات في UserDefaults
            UserDefaults.standard.set(startTime, forKey: "startTime")
            UserDefaults.standard.set(endTime, forKey: "endTime")
            UserDefaults.standard.set(notificationFrequency, forKey: "notificationFrequency")
            UserDefaults.standard.set(isExerciseEnabled, forKey: "isExerciseEnabled")
            UserDefaults.standard.set(isBreakEnabled, forKey: "isBreakEnabled")
            
            print("Preferences saved.")
        }
    }
    private func loadPreferences() {
        if let existingPreferences = preferences.first {
            startTime = existingPreferences.startTime
            endTime = existingPreferences.endTime
            notificationFrequency = existingPreferences.notificationFrequency
            isExerciseEnabled = existingPreferences.isExerciseEnabled
            isBreakEnabled = existingPreferences.isBreakEnabled
            isFirstTime = false
        } else {
            // تحميل الإعدادات من UserDefaults إذا لم تكن موجودة في SwiftData
            startTime = UserDefaults.standard.string(forKey: "startTime") ?? "9:00 AM"
            endTime = UserDefaults.standard.string(forKey: "endTime") ?? "5:00 PM"
            notificationFrequency = UserDefaults.standard.string(forKey: "notificationFrequency") ?? "Once"
            isExerciseEnabled = UserDefaults.standard.bool(forKey: "isExerciseEnabled")
            isBreakEnabled = UserDefaults.standard.bool(forKey: "isBreakEnabled")
        }
    }

    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current // استخدام توقيت الجهاز الحالي
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        guard let startDate = dateFormatter.date(from: startTime),
              let endDate = dateFormatter.date(from: endTime) else {
            print("Error: Invalid time format.")
            return
        }
        
        // التحقق من أن endDate أكبر من startDate
        guard startDate < endDate else {
            print("Error: End time must be after start time.")
            return
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        
        // تحديد عدد الإشعارات بناءً على الخيار المحدد
        let frequencyCount: Int
        switch notificationFrequency {
        case "Once":
            frequencyCount = 1
        case "Twice":
            frequencyCount = 2
        case "Four times":
            frequencyCount = 4
        default:
            frequencyCount = 1
        }
        
        let interval = duration / Double(frequencyCount)
        
        for i in 0..<frequencyCount {
            let notificationTime = startDate.addingTimeInterval(interval * Double(i))
            
            let content = UNMutableNotificationContent()
            content.title = "Reminder"
            content.body = "Check your posture! Open the app now!"
            content.sound = .default
            
            let triggerDate = calendar.dateComponents([.hour, .minute], from: notificationTime)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Reminder notification scheduled for: \(notificationTime)")
                }
            }
        }
        
        if isBreakEnabled {
            scheduleSingleNotification(for: "Break", during: startDate, endDate: endDate, center: center)
        }
        
        if isExerciseEnabled {
            scheduleSingleNotification(for: "Exercise", during: startDate, endDate: endDate, center: center)
        }
        
        print("Notifications scheduled.")
    }

    private func scheduleSingleNotification(for type: String, during startDate: Date, endDate: Date, center: UNUserNotificationCenter) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current // استخدام توقيت الجهاز الحالي
        
        // التحقق من أن endDate أكبر من startDate
        guard startDate < endDate else {
            print("Error: End time must be after start time.")
            return
        }
        
        // إنشاء وقت عشوائي ضمن النطاق الصحيح
        let randomTime = startDate.addingTimeInterval(TimeInterval.random(in: 0..<endDate.timeIntervalSince(startDate)))
        
        let content = UNMutableNotificationContent()
        content.title = type
        content.body = "It's time for your \(type.lowercased())!"
        content.sound = .default
        
        // تحديد وقت الإشعار باستخدام توقيت الجهاز
        let triggerDate = calendar.dateComponents([.hour, .minute], from: randomTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: "\(type)-\(UUID().uuidString)", content: content, trigger: trigger)
        center.add(request) { error in
            if let error = error {
                print("Error scheduling \(type.lowercased()) notification: \(error.localizedDescription)")
            } else {
                print("\(type) notification scheduled for: \(randomTime)")
            }
        }
    }
}

// مكون Toggle مخصص
struct CustomToggle: View {
    @Binding var isOn: Bool
    var activeColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 50, height: 30)
                .foregroundColor(isOn ? activeColor : Color.gray.opacity(0.3))
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .offset(x: isOn ? 10 : -10)
                .animation(.easeInOut(duration: 0.2), value: isOn)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}

func requestNotificationPermission() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
        if granted {
            print("Notification permission granted.")
        } else if let error = error {
            print("Notification permission error: \(error.localizedDescription)")
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
