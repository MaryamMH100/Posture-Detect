//
//  OnboardingViewModel.swift
//  PostureDetect
//
//  Created by Amaal Asiri on 09/09/1446 AH.
//
import Foundation
import SwiftUI
class OnboardingViewModel: ObservableObject {
    @Published var currentPageIndex = 0
    @AppStorage("hasCompletedOnboarding") var hasCompleted = false
    private let totalPages = 4
    
    func handleNext() {
        guard currentPageIndex < totalPages - 1 else {
            hasCompleted = true
            return
        }
        currentPageIndex += 1
    }
    
    func handleBack() {
        guard currentPageIndex > 0 else { return }
        currentPageIndex -= 1
    }
}
