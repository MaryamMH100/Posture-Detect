//
//  OnboardingView.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 03/09/1446 AH.
//

import SwiftData
import SwiftUI



struct OnboardingView: View {
    @State private var showPreferences = false

    var body: some View {
        VStack {
            if showPreferences {
                PreferencesView()
            } else {
                VStack(spacing: 20) {
                    Text("👋 مرحبًا بك في تطبيقنا!")
                        .font(.largeTitle)
                        .bold()
                    
                    Text("هذا التطبيق يساعدك في تنظيم وقتك بسهولة.")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()

                    Button(action: {
                        showPreferences = true
                    }) {
                        Text("التالي")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 40)
                }
            }
        }
        .animation(.easeInOut, value: showPreferences)
    }
}




struct HomeView: View {
    @State private var showPreferences = false

    var body: some View {
        NavigationView {
            VStack {
                Text("🏡 مرحبًا بك في الصفحة الرئيسية!")
                    .font(.largeTitle)
                    .bold()

                Button(action: {
                    showPreferences = true
                }) {
                    Text("⚙️ تعديل الإعدادات")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
                .sheet(isPresented: $showPreferences) {
                    PreferencesView()
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
