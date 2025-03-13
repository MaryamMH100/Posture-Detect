//
//  PostureDetectApp.swift
//  PostureDetect
//
//  Created by Maryam on 25/02/2025.
//
//
//  PostureDetectApp.swift
//  PostureDetect
//
//  Created by Maryam on 25/02/2025.
//

import SwiftUI
import Foundation
//import SwiftData

@main
struct MyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasCompletedPreferences") private var hasCompletedPreferences = false
    @State private var showPreferences = false  // إضافة هذه السطر لتعريف showPreferences
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if !hasCompletedPreferences {
                PreferencesView(showPreferences: $showPreferences, isOnboarding: true)
            } else {
                SessionView()
            }
        }
        .modelContainer(for: UserPreferences.self) // تهيئة SwiftData
    }
}
