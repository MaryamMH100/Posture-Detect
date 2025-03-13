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
    @State private var filteredEndTimeOptions: [String] = []
    @Binding var showPreferences: Bool // Binding to control the sheet visibility
    @State static private var showPreferences = true // تم تعريف الحالة هنا

    @State private var notificationFrequency = "Once"
    @State private var isExerciseEnabled = true
    @State private var isBreakEnabled = false
    @AppStorage("hasCompletedPreferences") private var hasCompletedPreferences = false
    @Environment(\.dismiss) private var dismiss
    @State private var isFirstTime = true
    @State private var navigateToSessionView = false
    var isOnboarding: Bool

    let timeOptions = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]
    
    let notificationOptions = ["Once", "Twice", "Four times"]

    var body: some View {
        NavigationStack {
            ZStack {
                if isOnboarding {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture { dismiss() }
                }

                VStack(alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Preferences").font(.largeTitle).bold()
                        Spacer()
                        
                        if isFirstTime {
                            Button("Skip") {
                                hasCompletedPreferences = true
                                dismiss()
                                navigateToSessionView = true
                            }
                            .foregroundColor(Color(red: 0.3, green: 0.44, blue: 0.27))
                            .padding(8)
//                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
//                            .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                        } else {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color.white)
                                    .padding(8)
                                    .background(Color(red: 0.3, green: 0.44, blue: 0.27))
.padding(8)
                               
                                    .background( Color(red: 0.3, green: 0.44, blue: 0.27))
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                            }
                            .buttonStyle(PlainButtonStyle())

                        }
                        
                    }
                    .buttonStyle(PlainButtonStyle())

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Session").font(.headline).bold().foregroundColor(.black)

                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .frame(height: 120)
                            .overlay(
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Work hours").foregroundColor(.black)
                                        Spacer()
                                        Picker("Start", selection: $startTime) {
                                            ForEach(timeOptions, id: \.self) { time in
                                                Text(time).foregroundColor(.black)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        .onChange(of: startTime) { _ in
                                            updateEndTimeOptions()
                                        }

                                        Picker("End", selection: $endTime) {
                                            ForEach(filteredEndTimeOptions, id: \.self) { time in
                                                Text(time).foregroundColor(.black)
                                            }
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                    }
                                    .onAppear(perform: loadPreferences)

                                    HStack {
                                        Text("Notifications frequency").foregroundColor(.black)
                                        Spacer()
                                        Picker("", selection: $notificationFrequency) {
                                            ForEach(notificationOptions, id: \.self) { option in
                                                Text(option).foregroundColor(.black)
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
                        Text("General").font(.headline).bold().foregroundColor(.black)
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .frame(height: 120)
                            .overlay(
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Exercise").foregroundColor(.black)
                                        Spacer()
                                        CustomToggle(isOn: $isExerciseEnabled, activeColor: Color(red: 0.3, green: 0.44, blue: 0.27))
                                    }

                                    HStack {
                                        Text("Break").foregroundColor(.black)
                                        Spacer()
                                        CustomToggle(isOn: $isBreakEnabled, activeColor: Color(red: 0.3, green: 0.44, blue: 0.27))
                                    }
                                }
                                .padding()
                            )
                    }

                    Button(action: {
                        savePreferences()
                        hasCompletedPreferences = true
                        dismiss()
                        navigateToSessionView = true
                    }) {
                        Text("Save")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.3, green: 0.44, blue: 0.27), Color(red: 0.2, green: 0.34, blue: 0.17)]), startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            
                            
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
        .onAppear {
            updateEndTimeOptions()
        }
        .navigationBarBackButtonHidden(isFirstTime)
        .background(
            NavigationLink(destination: SessionView(), isActive: $navigateToSessionView) {
                EmptyView()
            }
        )
        }
    }
    
    private func updateEndTimeOptions() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"

        if let startDate = dateFormatter.date(from: startTime) {
            filteredEndTimeOptions = timeOptions.filter { timeString in
                if let timeDate = dateFormatter.date(from: timeString) {
                    return timeDate > startDate
                }
                return false
            }

            if let firstAvailableTime = filteredEndTimeOptions.first {
                endTime = firstAvailableTime
            }
        }
    }

    private func savePreferences() {
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
        
        do {
            try modelContext.save()  // حفظ البيانات
            hasCompletedPreferences = true  // تم حفظ التفضيلات
        } catch {
            print("Error saving preferences: \(error.localizedDescription)")
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
        }
    }

    private func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        guard let startDate = dateFormatter.date(from: startTime),
              let endDate = dateFormatter.date(from: endTime) else {
            print("Error: Invalid time format.")
            return
        }
        
        guard startDate < endDate else {
            print("Error: End time must be after start time.")
            return
        }
        
        let duration = endDate.timeIntervalSince(startDate)
        
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
        calendar.timeZone = TimeZone.current
        
        guard startDate < endDate else {
            print("Error: End time must be after start time.")
            return
        }
        
        let randomTime = startDate.addingTimeInterval(TimeInterval.random(in: 0..<endDate.timeIntervalSince(startDate)))
        
        let content = UNMutableNotificationContent()
        content.title = type
        content.body = "It's time for your \(type.lowercased())!"
        content.sound = .default
        
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
    @State static private var showPreferences = true // تم تعريف الحالة هنا
    
    static var previews: some View {
        PreferencesView(showPreferences: $showPreferences, isOnboarding: true) // تم تمرير Binding<Bool>
    }
}
