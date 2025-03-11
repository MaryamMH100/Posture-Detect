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
    @AppStorage("hasSetPreferences") private var hasSetPreferences = false

    var body: some Scene {
        WindowGroup {
            if !hasCompletedOnboarding {
                OnboardingView() // الصفحة الأولى: شاشة الـ Onboarding
            } else if !hasSetPreferences {
                PreferencesView(isOnboarding: true) // الانتقال إلى PreferencesView
            } else {
                HomeView() // الصفحة الرئيسية
            }
        }
        .modelContainer(for: UserPreferences.self) // تهيئة SwiftData
    }
}
