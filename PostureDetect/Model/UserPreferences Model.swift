//
//  UserPreferences Model.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 06/09/1446 AH.
//

import Foundation
import SwiftData

@Model
final class UserPreferences {
    var startTime: String
    var endTime: String
    var notificationFrequency: String
    var isExerciseEnabled: Bool
    var isBreakEnabled: Bool

    init(startTime: String = "9:00 AM", endTime: String = "5:00 PM",
         notificationFrequency: String = "Once", isExerciseEnabled: Bool = true, isBreakEnabled: Bool = false) {
        self.startTime = startTime
        self.endTime = endTime
        self.notificationFrequency = notificationFrequency
        self.isExerciseEnabled = isExerciseEnabled
        self.isBreakEnabled = isBreakEnabled
    }
}
