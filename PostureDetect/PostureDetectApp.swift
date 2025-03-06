//
//  PostureDetectApp.swift
//  PostureDetect
//
//  Created by Maryam on 25/02/2025.
//

import SwiftUI
import SwiftData
@main
struct MyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                HomeView()
            } else {
                PreferencesView()
            }
        }
        .modelContainer(for: UserPreferences.self) // تهيئة SwiftData
    }
}
