//
//  CircularSliderViewModel.swift
//  PostureDetect
//
//  Created by Maryam on 12/03/2025.
//

import Foundation
import AVFoundation

class SessionViewModel: ObservableObject {
    @Published var selectedTime: Double = 0
    @Published var timeRemaining: Double = 0
    @Published var timerRunning = false
    @Published var cameraPermissionDenied = false
    @Published var isMonitoring = false

    private var timer: Timer?
    private let cameraManager = CameraManager()

    func startTimer() {
        DispatchQueue.main.async { // Ensure UI updates on main thread
            self.timerRunning = true
            self.isMonitoring = true
            self.cameraManager.startCamera(withDuration: 30 * 60)

            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1 / 60
                } else {
                    self.stopTimer()
                }
            }
        }
    }

    func pauseTimer() {
        DispatchQueue.main.async { // Ensure UI updates on main thread
            self.timer?.invalidate()
            self.timer = nil
            self.timerRunning = false
            self.cameraManager.stopCamera()
            self.isMonitoring = false
        }
    }

    func stopTimer() {
        DispatchQueue.main.async { // Ensure UI updates on main thread
            self.timer?.invalidate()
            self.timer = nil
            self.timerRunning = false
            self.timeRemaining = 0
            self.selectedTime = 0
            self.cameraManager.stopCamera()
            self.isMonitoring = false
        }
    }

    func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        DispatchQueue.main.async { // Ensure UI updates on main thread
            self.cameraPermissionDenied = (status == .denied || status == .restricted)
        }
    }
}
