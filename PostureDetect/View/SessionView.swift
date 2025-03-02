//
//  SessionView.swift
//  PostureDetect
//
//  Created by Maryam on 02/03/2025.
//

import SwiftUI

struct SessionView: View {
    @State private var selectedTime: Double = 0 // Default to 1 minute
    @State private var timeRemaining: Double = 0 // Default to 1 minute
    @State private var timerRunning = false
    @State private var timer: Timer?

    var body: some View {
        VStack {
            HStack {
                Button {
                    // preferences popup
                } label: {
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

                Spacer(minLength: 70)

                Text("Start the timer and track your posture")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Spacer(minLength: 70)

                Button {
                    // exercises screen
                } label: {
                    HStack {
                        Text("Exercises")
                            .foregroundColor(.white)

                        Image(systemName: "figure.cooldown")
                            .foregroundColor(.white)
                    }
                    .frame(width: 120, height: 30)
                }
                .background(Color("lightGreen"))
                .cornerRadius(5)
                .padding()
            }
            
            Spacer(minLength: 20)

            // Circular Slider
            CircularSlider(selectedTime: $selectedTime, timeRemaining: $timeRemaining, timerRunning: $timerRunning)
                .frame(width: 400, height: 400)

            Spacer(minLength: 20)

            // Timer Controls
            HStack {
                Button(action: {
                    timer?.invalidate()
                    timerRunning = false
                    timeRemaining = 0
                    selectedTime = 0// Reset to selected time
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("disableButton"))
                            .frame(width: 100, height: 100)

                        Text("Cancel")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
                .cornerRadius(100)
                .disabled(!timerRunning) // Disable if timer is not running

                Spacer(minLength: 48)

                Button(action: {
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
                            }
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(Color("lightGreen"))
                            .frame(width: 100, height: 100)

                        Text(timerRunning ? "Pause" : "Start")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .cornerRadius(100)
            }
            .frame(width: 388, height: 101)

            Spacer(minLength: 70)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BackgroundColor"))
    }
}

#Preview {
    SessionView()
}
