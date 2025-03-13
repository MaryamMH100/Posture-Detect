//
//  SessionView.swift
//  PostureDetect
//
//  Created by Maryam on 02/03/2025.
//


import SwiftUI
import _SwiftData_SwiftUI

struct SessionView: View {
    @StateObject private var viewModel = SessionViewModel()
    @State private var showPreferences = false
    
    @Query private var preferences: [UserPreferences]
    @Environment(\.modelContext) private var modelContext
    
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasCompletedPreferences") private var hasCompletedPreferences = false
    //    @State private var navigateToSessionView = true
    
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
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer(minLength: 20)
                
                if viewModel.cameraPermissionDenied {
                    Text("⚠ Camera access is required to track your posture.")
                        .foregroundColor(.red)
                        .font(.title)
                        .padding()
                }
                
                Spacer(minLength: 20)
                
                CircularSlider(selectedTime: $viewModel.selectedTime, timeRemaining: $viewModel.timeRemaining, timerRunning: $viewModel.timerRunning)
                    .frame(width: 450, height: 450)
                
                Spacer(minLength: 20)
                
                HStack {
                    Button(action: {
                        viewModel.stopTimer()
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(Color("disableButton"))
                                .frame(width: 100, height: 100)
                            
                            Text("Cancel")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(viewModel.timerRunning ? .black : .gray)
                        }
                    }
                    .cornerRadius(100)
                    .disabled(!viewModel.timerRunning)
                    
                    Spacer(minLength: 48)
                    
                    Button(action: {
                        if viewModel.timerRunning {
                            viewModel.pauseTimer()
                        } else {
                            viewModel.startTimer()
                        }
                    }) {
                        ZStack {
                            Circle()
                                .foregroundColor(viewModel.cameraPermissionDenied ? Color("disabledGreen") : Color("lightGreen"))
                                .frame(width: 100, height: 100)
                            
                            Text(viewModel.timerRunning ? "Pause" : "Start")
                                .font(.system(size: 20, weight: .medium))
                                .foregroundColor(viewModel.cameraPermissionDenied ? .gray : .white)
                        }
                    }
                    .disabled(viewModel.cameraPermissionDenied)
                    .cornerRadius(100)
                }
                .frame(width: 388, height: 101)
                
                Spacer(minLength: 70)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("BackgroundColor"))
            .onAppear {
                viewModel.checkCameraPermission()
            }
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
