//
//  PreferencesView.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 06/09/1446 AH.
//

import Foundation
import SwiftUI
import SwiftData
struct PreferencesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var preferences: [UserPreferences]
    @State private var startTime = "9:00 AM"
    @State private var endTime = "5:00 PM"
    @State private var notificationCount = 5
    @State private var isExerciseEnabled = true
    @State private var isBreakEnabled = false
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @Environment(\.presentationMode) var presentationMode
    @State private var isFirstTime = true

    let timeOptions = ["12:00 AM", "1:00 AM", "2:00 AM", "3:00 AM", "4:00 AM", "5:00 AM", "6:00 AM", "7:00 AM", "8:00 AM", "9:00 AM", "10:00 AM", "11:00 AM", "12:00 PM", "1:00 PM", "2:00 PM", "3:00 PM", "4:00 PM", "5:00 PM", "6:00 PM", "7:00 PM", "8:00 PM", "9:00 PM", "10:00 PM", "11:00 PM"]

    var workDuration: Int {
        guard let startIndex = timeOptions.firstIndex(of: startTime),
              let endIndex = timeOptions.firstIndex(of: endTime) else { return 1 }
        let hours = (endIndex - startIndex + 24) % 24
        return max(hours, 1)
    }

    var notificationInterval: Int {
        return workDuration / max(notificationCount, 1)
    }

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
                        presentationMode.wrappedValue.dismiss()
                            }
    .foregroundColor(Color(red: 0.3, green: 0.44, blue: 0.27))
                                   }
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Session").font(.headline).bold()

                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .background(Color.white)
                        .frame(height: 120)
                        .overlay(
                            VStack(spacing: 15) {
                                HStack {
                                    Text("Work hours")
                                    Spacer()
                                    Picker("Start", selection: $startTime) {
                                        ForEach(timeOptions, id: \.self) { Text($0) }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 130)

                                    Picker("End", selection: $endTime) {
                                        ForEach(timeOptions, id: \.self) { Text($0) }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 130)
                                }

                                HStack {
                                    Text("Notifications frequency")
                                    Spacer()
                                    Picker("", selection: $notificationCount) {
                                        ForEach(1...20, id: \.self) { num in
                                            Text("\(num)").tag(num)
                                        }
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    .frame(width: 120)
                                }
                            }
                            .padding()
                        )
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("General").font(.headline).bold()
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        .background(Color.white)
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

                Button(action: savePreferences) {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.3, green: 0.44, blue: 0.27))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            .padding()
            .frame(width: 500, height: 500)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.55), radius: 1.5, x: 0, y: 0)
            .onTapGesture {} // منع الإغلاق عند الضغط داخل الإطار
        }
        .onAppear(perform: loadPreferences)
    }

    private func savePreferences() {
        if let existingPreferences = preferences.first {
            existingPreferences.startTime = startTime
            existingPreferences.endTime = endTime
            existingPreferences.notificationFrequency = "\(notificationCount) Notifications"
            existingPreferences.isExerciseEnabled = isExerciseEnabled
            existingPreferences.isBreakEnabled = isBreakEnabled
        } else {
            let newPreferences = UserPreferences(
                startTime: startTime,
                endTime: endTime,
                notificationFrequency: "\(notificationCount) Notifications",
                isExerciseEnabled: isExerciseEnabled,
                isBreakEnabled: isBreakEnabled
            )
            modelContext.insert(newPreferences)
        }

        hasCompletedOnboarding = true
        isFirstTime = false
        presentationMode.wrappedValue.dismiss()
    }

    private func loadPreferences() {
        if let existingPreferences = preferences.first {
            startTime = existingPreferences.startTime
            endTime = existingPreferences.endTime
            if let notifications = Int(existingPreferences.notificationFrequency.split(separator: " ")[0]) {
                notificationCount = notifications
            }
            isExerciseEnabled = existingPreferences.isExerciseEnabled
            isBreakEnabled = existingPreferences.isBreakEnabled
            isFirstTime = false
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
            
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .offset(x: isOn ? 10 : -10)
                .animation(.easeInOut(duration: 0.2), value: isOn)
        }
        .onTapGesture {
            isOn.toggle()
        }
    }
}
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
