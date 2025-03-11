//
//  Untitled.swift
//  PostureDetect
//
//  Created by Shaima Bashammakh on 11/09/1446 AH.
//

import SwiftUI
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
                Image(Bool.random() ? "Done" : "Done2").resizable().scaledToFit().frame(height: 350)
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
//                Button(action: {
//                    if viewModel.isActive {
//                        viewModel.isActive = false
//                        viewModel.timer?.invalidate()
//                    } else {
//                        viewModel.startExercises(for: category)
//                    }
//                }) {
//                    Text(viewModel.isActive ? "End Exercises" : "Start Exercises")
//                        .font(.title) // Adjust font size
//                        .fontWeight(.bold) // Makes text bold
//                        .foregroundColor(.white) // Text color
//                        .padding(.horizontal, 40) // Horizontal padding
//                        .padding(.vertical, 15) // Vertical padding
//                        .frame(width: 400, height: 46) // Adjust width and height
//                        .buttonStyle(PlainButtonStyle())
//                       .background(Color("CustomGreen")).ignoresSafeArea() // Button background color
//
//                        .cornerRadius(5) // Rounded corners
//                        .shadow(radius: 3) // Optional shadow
//                }.padding(.top,30)
                
                
                Button(action: {
                    if viewModel.isActive {
                        viewModel.isActive = false
                        viewModel.timer?.invalidate()
                    } else {
                        viewModel.startExercises(for: category)
                    }
                }) {
                    Text(viewModel.isActive ? "End Exercises" : "Start Exercises")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .frame(width: 400, height: 46)
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color("CustomGreen")))
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.top, 30)

                
            }

            
        }
        .background(Color.clear)
       //.background(Color("CustomGrey"))
        .ignoresSafeArea()
        .navigationTitle(category.name)
        .padding()
    }
}


