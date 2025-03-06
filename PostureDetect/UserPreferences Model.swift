//
//  UserPreferences Model.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 06/09/1446 AH.
//

import Foundation
import SwiftUI
import SwiftData
@Model
class UserPreferences {
    var startTime: String
    var endTime: String
    var notificationFrequency: String
    var isExerciseEnabled: Bool
    var isBreakEnabled: Bool
    
    init(startTime: String = "1:30 PM",
         endTime: String = "1:00 PM",
         notificationFrequency: String = "Every 20 min",
         isExerciseEnabled: Bool = true,
         isBreakEnabled: Bool = false) {
        self.startTime = startTime
        self.endTime = endTime
        self.notificationFrequency = notificationFrequency
        self.isExerciseEnabled = isExerciseEnabled
        self.isBreakEnabled = isBreakEnabled
    }
}
