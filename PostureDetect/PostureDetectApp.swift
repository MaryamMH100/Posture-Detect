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
    @AppStorage("isFirstLaunchAfterReinstall") private var isFirstLaunchAfterReinstall = true
    @State private var showPreferences = false
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if isFirstLaunchAfterReinstall {
                OnboardingView()
                    .onAppear {
                        hasCompletedOnboarding = false
                        hasCompletedPreferences = false
                        isFirstLaunchAfterReinstall = false
                    }
            } else {
                SessionView()
            }
        }
        .modelContainer(for: UserPreferences.self)
    }
}
