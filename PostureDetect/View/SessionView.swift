//
//  SessionView.swift
//  PostureDetect
//
//  Created by Maryam on 02/03/2025.
//

import SwiftUI
import AVFoundation
import SwiftData

struct SessionView: View {
    @State private var selectedTime: Double = 0 // Default to 1 minute
    @State private var timeRemaining: Double = 0 // Default to 1 minute
    @State private var timerRunning = false
    @State private var timer: Timer?
    @State private var isMonitoring = false
    @StateObject private var cameraManager: CameraManager
    // تم تعريف الحالة هنا
    @State private var cameraPermissionDenied = false // Track permission status
    @State private var showPreferences = false
    @Query private var preferences: [UserPreferences]
    @Environment(\.modelContext) private var modelContext

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasCompletedPreferences") private var hasCompletedPreferences = false
//    @State private var navigateToSessionView = true
    
    
    init() {
        let appDelegate = NSApp.delegate as? AppDelegate
        _cameraManager = StateObject(wrappedValue: CameraManager())
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Button(action: {
                        showPreferences = true
                    }) {
                        HStack {
                            Text("Preferences")
                                .foregroundColor(Color("StrokeColor"))
                            
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(Color("StrokeColor"))
                        }
                        .frame(width: 120, height: 30)
                    }
                    .border(Color("disableButton"), width: 1)
                    .background(.white)
                    .padding()
                    .cornerRadius(5)
                    .sheet(isPresented: $showPreferences) {
                        PreferencesView(showPreferences: $showPreferences, isOnboarding: false)
                            .onDisappear {
                                showPreferences = false
                            }
                    }
                    .onAppear {
                        loadPreferences()
                    }
                
                    
                    Spacer(minLength: 70)
                    
                    Text("Start the timer and track your posture")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                    
                    Spacer(minLength: 70)
                    
                    NavigationLink(destination: ExerciseView()) {
                        
                        HStack {
                            Text("Exercises")
                                .foregroundColor(.white)
                            
                            Image(systemName: "figure.cooldown")
                                .foregroundColor(.white)
                        }
                        .frame(width: 120, height: 30)
                        .buttonStyle(PlainButtonStyle())
                        .background(Color("lightGreen"))
                        .cornerRadius(5)
                        .padding()
                    }.buttonStyle(PlainButtonStyle())
                }
                
                Spacer(minLength: 20)
                
                // ** Warning text if camera permission is denied **
                if cameraPermissionDenied {
                    Text("⚠ Camera access is required to track your posture.")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding()
                }
                
                Spacer(minLength: 20)
                
                // Circular Slider
                CircularSlider(selectedTime: $selectedTime, timeRemaining: $timeRemaining, timerRunning: $timerRunning)
                    .frame(width: 450, height: 450)
                
                Spacer(minLength: 20)
                
                // Timer Controls
                HStack {
                    Button(action: {
                        
                        
                        timer?.invalidate()
                        timerRunning = false
                        timeRemaining = 0
                        selectedTime = 0// Reset to selected time
                        cameraManager.stopCamera() // إيقاف الكاميرا
                        
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("disableButton"))
                                .frame(width: 100, height: 100)
                            
                            Text("Cancel")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(timerRunning ? .black : .gray)
                        }
                    }
                    .cornerRadius(100)
                    .disabled(!timerRunning) // Disable if timer is not running
                    
                    Spacer(minLength: 48)
                    
                    Button(action: {
                        
                        isMonitoring.toggle()
                        if isMonitoring {
                            print("Starting camera monitoring...")
                            cameraManager.startCamera(withDuration: 30 * 60)
                        }
                        
                        if timerRunning {
                            timer?.invalidate()
                            timerRunning = false
                        } else {
                            timeRemaining = selectedTime // Reset to selected time
                            timerRunning = true
                            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1 / 60 // Decrement by 1 second (1/60 of a minute)
                                } else {
                                    timer?.invalidate()
                                    timerRunning = false
                                    cameraManager.stopCamera() // Stop camera when time reaches 0
                                    isMonitoring = false
                                }
                            }
                        }
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(cameraPermissionDenied ? Color("disabledGreen") : Color("lightGreen") )
                                .frame(width: 100, height: 100)
                            
                            Text(timerRunning ? "Pause" : "Start")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(cameraPermissionDenied ? .gray : .white)
                        }
                    }
                    .disabled(cameraPermissionDenied)
                    .cornerRadius(100)
                }
                .frame(width: 388, height: 101)
                
                Spacer(minLength: 70)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            .onAppear {
                checkCameraPermission() // Check camera access when view appears
            }
        }
        
    }
    
    private func checkCameraPermission() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        DispatchQueue.main.async {
            self.cameraPermissionDenied = (status == .denied || status == .restricted)
        }
    }
    private func loadPreferences() {
        // إذا كانت الإعدادات فارغة في SwiftData، قم بإنشاء إعدادات جديدة
        if preferences.isEmpty {
            let newPreferences = UserPreferences(
                startTime: "9:00 AM",  // الوقت الافتراضي
                endTime: "5:00 PM",    // الوقت الافتراضي
                notificationFrequency: "Once",  // الافتراضي
                isExerciseEnabled: true,  // افتراضي تمكين التمرين
                isBreakEnabled: false    // افتراضي تمكين الاستراحة
            )
            
            // إضافة الإعدادات الجديدة إلى modelContext
            modelContext.insert(newPreferences)
            do {
                try modelContext.save()  // حفظ البيانات
            } catch {
                print("Error saving preferences: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    SessionView()
        .frame(minWidth: 1440, minHeight: 900)
}
