//
//  ContentView.swift
//  PostureDetect
//
//  Created by Maryam on 25/02/2025.
//


import SwiftUI

// Model
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let image: String
}

struct ExerciseCategory: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [Exercise]
    let image: String
    let time: Int
}


// ViewModel
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
struct ExerciseListView: View {
    @StateObject var viewModel = ExerciseViewModel() // Persistent ViewModel
    let category: ExerciseCategory

    var body: some View {
        VStack {
            if let currentExercise = viewModel.currentExercise {
                Spacer()
                
                Text(currentExercise.name)
                    .font(.title)
                Image(currentExercise.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350).padding()
                    //.frame(height: 100)
                
                Text("Time remaining: \(viewModel.timeRemaining) sec")
                    .font(.title2)
                
                Spacer()
            }
            
            
            
            if viewModel.isFinished { // Show "End" if exercises are finished
                Text (category.name).font(.title)
              
                Text("\(category.time) Seconds")
                    .font(.title2)
                Image("ExercisesDone").resizable().scaledToFit().frame(height: 350)
//                    .font(.title)
//                    .foregroundColor(.red)
                    .padding()
            } else if !viewModel.isActive { // Show "Start" only if timer is not active
                Text (category.name).font(.title)
                
                Text("\(category.time) Seconds")
                    .font(.title2)
                Image(category.image).resizable().scaledToFit().frame(height: 350)
                //                    .font(.title)
                //                    .foregroundColor(.green)
                    .padding()
            }
            
            
            
            if !viewModel.isActive {
                Button(action: {
                    if viewModel.isActive {
                        viewModel.isActive = false
                        viewModel.timer?.invalidate()
                    } else {
                        viewModel.startExercises(for: category)
                    }
                }) {
                    Text(viewModel.isActive ? "End Exercises" : "Start Exercises")
                        .font(.title) // Adjust font size
                        .fontWeight(.bold) // Makes text bold
                        .foregroundColor(.white) // Text color
                        .padding(.horizontal, 40) // Horizontal padding
                        .padding(.vertical, 15) // Vertical padding
                        .frame(width: 400, height: 46) // Adjust width and height
                        .background(Color("CustomGreen")) // Button background color
                        .cornerRadius(5) // Rounded corners
                        .shadow(radius: 3) // Optional shadow
                }.padding(.top,30)
            }

            
        }
        .background(Color.clear)
       //.background(Color("CustomGrey"))
        .ignoresSafeArea()
        .navigationTitle(category.name)
        .padding()
    }
}

// view
struct ContentView: View {
    let categories = [
        ExerciseCategory(name: "Neck Stretch", exercises: [
                        Exercise(name: "Left Neck Stretch", duration: 15, image: "LeftNeckExercise"),
                        Exercise(name: "Right Neck Stretch", duration: 15, image: "RightNeckExercise"),
                        Exercise(name: "Forward Neck Stretch", duration: 15, image: "DownNeckExercise"),
                        Exercise(name: "Upward Neck Stretch", duration: 15, image: "UpNeckExercise")
        ], image: "Neck", time: 60),
        
        
        ExerciseCategory(name: "Back Stretch", exercises: [
            Exercise(name: "Back Stretch", duration: 20, image: "BackExercise")], image: "Back",time: 20),
        
        ExerciseCategory(name: "Eyes Exercise", exercises: [
                        Exercise(name: "Far Away Focus", duration: 20, image: "LookFarAwayEyeExercise"),
                        Exercise(name: " Circular Motion Exercise", duration: 20, image: "EyeCircularMotionExercise"),
                        Exercise(name: "Blink Eye Exercise", duration: 20, image: "BlinkEyeExercise")
                    ], image: "Eyes", time: 60),
        
        ExerciseCategory(name: "Shoulders Stretch", exercises: [Exercise(name: "Right Shoulders Stretch", duration: 15, image: "Shoulders1"),
            Exercise(name: "Left Shoulders Stretch", duration: 15, image: "Shoulders2"),
            Exercise(name: "Right Shoulders Stretch", duration: 15, image: "Shoulders3"),
            Exercise(name: "Left Shoulders Stretch", duration: 15, image: "Shoulders4"),
            Exercise(name: "Right Triceps Stretch", duration: 15, image: "Shoulders6"),
            Exercise(name: "Left Triceps Stretch", duration: 15, image: "Shoulders5")]
        , image: "Shoulders",time: 90)
    ]

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let columns = [GridItem(.adaptive(minimum: 300, maximum: 400), spacing: 15)]
                
                ScrollView {
                    HStack {
                        Spacer()
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(categories) { category in
                                NavigationLink(destination: ExerciseListView(category: category)) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.white)
                                            .shadow(radius: 3)

                                        VStack(alignment: .leading) {
                                            Image(category.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 200)
                                                .cornerRadius(12)
                                                .padding(.bottom, 8)
                                            
                                            Divider()
                                            
                                            Text(category.name)
                                                .font(.title2)
                                                //.font(.headline)
                                                .foregroundColor(.primary)
                                                .padding(.top,10)
                                                //.padding(.horizontal)
                                                //.padding(.trailing,130)
                                            
                                            Text("\(category.time) Seconds")
                                                .font(.title3)
                                                //.font(.subheadline)
                                                //.font(.largeTitle)
                                                .foregroundColor(.gray)
                                                //.padding(.horizontal)
                                                //.padding(.trailing,220)
                                            
                                            Spacer()
                                            
                                            HStack {
                                                Spacer()
                                                Text("Start >")
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                    .padding(.horizontal, 16)
                                                    .padding(.vertical, 8)
                                                    .background(Color("CustomGreen"))
                                                    .cornerRadius(5)
                                                    .padding(.bottom)
                                                    .bold()
                                            }
                                        }
                                        .padding()
                                    }
                                    .frame(width: min(geometry.size.width * 0.4, 283), height: 376)
                                    .contentShape(Rectangle()) // Fixes tap area issues
                                    
                                    
                                }
                                .buttonStyle(PlainButtonStyle()) // Removes default NavigationLink styling
                            }
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Exercises")
            .background(Color("CustomGrey"))
            .ignoresSafeArea()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


