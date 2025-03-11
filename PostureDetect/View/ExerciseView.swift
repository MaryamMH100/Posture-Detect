//
//  Untitled 2.swift
//  PostureDetect
//
//  Created by Shaima Bashammakh on 11/09/1446 AH.
//


import SwiftUI
// view
struct ExerciseView: View {
    let categories = [
        ExerciseCategory(name: "Neck Stretch", exercises: [
                        Exercise(name: "Left Neck Stretch", duration: 15, image: "LeftNeckExercise"),
                        Exercise(name: "Right Neck Stretch", duration: 15, image: "RightNeckExercise"),
                        Exercise(name: "Forward Neck Stretch", duration: 15, image: "DownNeckExercise"),
                        Exercise(name: "Upward Neck Stretch", duration: 15, image: "UpNeckExercise")
        ], image: "Neck", time: 60),
        
        
        ExerciseCategory(name: "Back Stretch", exercises: [
            Exercise(name: "Back Stretch", duration: 20, image: "BackExercise"),
            Exercise(name: "Back Stretch", duration: 20, image: "Back2"),
            Exercise(name: "Back Stretch", duration: 20, image: "Back3")], image: "Back",time: 60),
        
        ExerciseCategory(name: "Eyes Exercise", exercises: [
                        Exercise(name: "Far Away Focus", duration: 20, image: "LookFarAwayEyeExercise"),
                        Exercise(name: " Closed-Eye Circular Motion Exercise", duration: 20, image: "EyeCircularMotionExercise"),
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



