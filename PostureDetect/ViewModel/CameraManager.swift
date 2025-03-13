//
//  CameraManager.swift
//  PostureDetect
//
//  Created by Maryam on 07/03/2025.
//

import AVFoundation
import CoreImage
import UserNotifications

class CameraManager: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private let captureSession = AVCaptureSession()
    private let postureDetector = PostureDetector()
    private var timer: Timer?
    private var wrongPostureStartTime: Date?
    private let postureDurationThreshold: TimeInterval = 20
    private let confidenceThreshold: Float = 0.85

    private var appDelegate: AppDelegate? {
        return AppDelegate.shared
    }

    override init() {
        super.init()
    }

    func startCamera(withDuration duration: TimeInterval) {
        DispatchQueue.global(qos: .userInitiated).async { // Run on background thread
            self.setupCamera()
        }

        timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.stopCamera()
        }
    }

    private func setupCamera() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let input = try? AVCaptureDeviceInput(device: device) else { return }

        captureSession.addInput(input)

        let output = AVCaptureVideoDataOutput()
        output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(output)

        captureSession.startRunning()
    }

    func stopCamera() {
        DispatchQueue.global(qos: .userInitiated).async { // Run on background thread
            self.captureSession.stopRunning()
        }
        timer?.invalidate()
        timer = nil
        wrongPostureStartTime = nil
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)

        DispatchQueue.global(qos: .userInitiated).async { // Run on background thread
            self.postureDetector.detectPosture(from: ciImage) { posture, confidence in
                DispatchQueue.main.async { // Update UI on main thread
                    if let posture = posture, posture == "WrongPosture" {
                        if self.wrongPostureStartTime == nil {
                            self.wrongPostureStartTime = Date()
                        }

                        if let startTime = self.wrongPostureStartTime,
                           Date().timeIntervalSince(startTime) >= self.postureDurationThreshold,
                           confidence >= self.confidenceThreshold {
                            self.showNotification()
                            self.wrongPostureStartTime = nil
                        }
                    } else {
                        self.wrongPostureStartTime = nil
                    }
                }
            }
        }
    }

    private func showNotification() {
        DispatchQueue.main.async { // Ensure UI updates on main thread
            print("Calling showPopover from CameraManager...")
            self.appDelegate?.showPopover()
        }
    }
}
