//
//  Untitled.swift
//  PostureDetect
//
//  Created by Shaima Bashammakh on 11/09/1446 AH.
//


import SwiftUI
class ExerciseViewModel: ObservableObject {
    @Published var currentExercise: Exercise? = nil
    @Published var timeRemaining: Int = 0
    @Published var isActive: Bool = false
    @Published var isFinished: Bool = false // Flag to check if exercises are finished
    
    var timer: Timer?
    private var currentIndex: Int = 0
    private var exerciseList: [Exercise] = []
    
    @Published var image: Bool = false
    
    func startExercises(for category: ExerciseCategory) {
        exerciseList = category.exercises
        currentIndex = 0
        nextExercise()
        image = true
        isFinished = false // Reset finished flag
    }
    
    private func nextExercise() {
        guard currentIndex < exerciseList.count else {
            isActive = false // Finished all exercises
            currentIndex = 0 // Reset the index
            currentExercise = nil // Clear current exercise
            isFinished = true // Set finished flag to true
            return
        }
        
        currentExercise = exerciseList[currentIndex]
        timeRemaining = currentExercise?.duration ?? 0
        isActive = true
        currentIndex += 1
        startTimer()
        image = false
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.invalidate()
                    self.nextExercise()
                }
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

// view
