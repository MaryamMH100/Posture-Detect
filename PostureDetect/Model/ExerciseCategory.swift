//
//  Untitled.swift
//  PostureDetect
//
//  Created by Shaima Bashammakh on 11/09/1446 AH.
//

import SwiftUI


struct ExerciseCategory: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [Exercise]
    let image: String
    let time: Int
}
