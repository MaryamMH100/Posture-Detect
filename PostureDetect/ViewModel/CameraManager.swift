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
    private var wrongPostureStartTime: Date? // لتخزين وقت البداية عندما تبدأ الوضعية الخاطئة
    private let postureDurationThreshold: TimeInterval = 30 // مدة 30 ثانية
    private let confidenceThreshold: Float = 0.85 // الحد الأدنى للثقة الذي نريد التحقق منه

    private var appDelegate: AppDelegate? {
        return AppDelegate.shared
    }

    
    override init() {
        super.init()
    }
    
    func startCamera(withDuration duration: TimeInterval) {
        setupCamera()
        
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
        captureSession.stopRunning()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        print("Is main thread: \(Thread.isMainThread)") // أضف هذا السطر
        DispatchQueue.main.async {
            print("Is main thread after dispatch: \(Thread.isMainThread)") // أضف هذا السطر
            self.postureDetector.detectPosture(from: ciImage) { posture, confidence in
                if let posture = posture, posture == "WrongPosture" {
                    // إذا كانت الوضعية خاطئة
                    if self.wrongPostureStartTime == nil {
                        // إذا كانت أول مرة نكتشف فيها الوضعية الخاطئة، نبدأ المؤقت
                        self.wrongPostureStartTime = Date()
                    }

                    // تحقق إذا كانت المدة قد تجاوزت 30 ثانية ونسبة الثقة أعلى من الحد المطلوب
                    if let startTime = self.wrongPostureStartTime, Date().timeIntervalSince(startTime) >= self.postureDurationThreshold, confidence >= self.confidenceThreshold {
                        self.showNotification()  // عرض التنبيه إذا استمرت الوضعية الخاطئة لمدة 30 ثانية و كانت نسبة الثقة كافية
                        self.wrongPostureStartTime = nil // إعادة تعيين الوقت بعد عرض التنبيه
                    }
                } else {
                    // إذا تحسنت الوضعية، إعادة تعيين المؤقت
                    self.wrongPostureStartTime = nil
                }
            }

        }
    }
    
    private func showNotification() {
        print("Attempting to show notification...")
        DispatchQueue.main.async {
            print("Calling showPopover from CameraManager...")
            print("AppDelegate is nil: \(self.appDelegate == nil)")

            self.appDelegate?.showPopover()
        }
    }
}
