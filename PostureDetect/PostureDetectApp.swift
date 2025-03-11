//
//  PostureDetectApp.swift
//  PostureDetect
//
//  Created by Maryam on 25/02/2025.
//

import SwiftUI

@main
struct PostureDetectApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
//            ContentView()
            SessionView()
        }
    }
}
