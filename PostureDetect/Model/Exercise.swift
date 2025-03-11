//
//  Untitled.swift
//  PostureDetect
//
//  Created by Shaima Bashammakh on 11/09/1446 AH.
//

import SwiftUI

// Model
struct Exercise: Identifiable {
    let id = UUID()
    let name: String
    let duration: Int
    let image: String
}
