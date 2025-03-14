import SwiftUI
import Foundation

@main
struct MyApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("isFirstLaunchAfterReinstall") private var isFirstLaunchAfterReinstall = true
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            if isFirstLaunchAfterReinstall {
                OnboardingView()
                    .onAppear {
                        isFirstLaunchAfterReinstall = false // يمنع ظهور Onboarding مرة أخرى
                    }
            } else {
                SessionView()
            }
        }
    }
}
