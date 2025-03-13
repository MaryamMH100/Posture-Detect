//
//  SessionAlerts.swift
//  PostureDetect
//
//  Created by Maryam on 11/03/2025.
//

import SwiftUI

struct SessionAlerts: View {
    
    let messages = [
        "Fix your posture👀",
        "Sit up straight! 😊",
        "No slouching! 🚀",
        "Straighten your back! 🏋️‍♂️"
    ]
    
    @State private var currentMessage: String
    
    init() {
        _currentMessage = State(initialValue: messages.randomElement() ?? "Fix your posture👀")
    }
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(currentMessage))
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .frame(width: 300, height: 100)
        .onAppear {
            currentMessage = messages.randomElement() ?? "Fix your posture👀"
        }
    }
}

#Preview {
    SessionAlerts()
}
