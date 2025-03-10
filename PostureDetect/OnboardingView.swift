//
//  OnboardingView.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 03/09/1446 AH.
//

import SwiftData
import SwiftUI


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

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showPreferences = false
    
    var body: some View {
        VStack {
            if showPreferences {
                PreferencesView()
            } else {
                ZStack {
                    // Background color applied first
                    Color("BackgroundColor")
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Spacer()
                            if viewModel.currentPageIndex < 3 {
                                Button(action: {
                                    viewModel.hasCompleted = true
                                    showPreferences = true
                                }) {
                                    Text("Skip")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(Color("fontColor"))
                                        .padding()
                                        .padding(.top, 0)
                                        .padding(.trailing, 5)
                                }
                                .background(Color.clear) // Ensure NO background
                                .buttonStyle(.plain) // Remove default button style
                            }
                        }
                        
                        VStack(spacing: 20) {
                            switch viewModel.currentPageIndex {
                            case 0: OnboardingPage1()
                            case 1: OnboardingPage2()
                            case 2: OnboardingPage3()
                            case 3: OnboardingPage4()
                            default: OnboardingPage1()
                            }
                        }
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)
                        ))
                        
                        Spacer()
                        
                        Button(action: {
                            if viewModel.currentPageIndex == 3 {
                                showPreferences = true
                            } else {
                                viewModel.handleNext()
                            }
                        }) {
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color("fontColor"))
                                    .frame(width: 700, height: 40)
                                
                                Text(viewModel.currentPageIndex == 3 ? "Start" : "Next")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(.white)
                                    .padding(.bottom, 1)
                            }
                        }
                        .cornerRadius(35)
                    }
                    .padding(.bottom, 70)
                }
                .frame(width: 1300, height: 700)
            }
        }
        .animation(.easeInOut, value: showPreferences)
    }
}

struct OnboardingPage1: View {
    var body: some View {
        VStack(spacing: 10) {
            Image("OnBoarding1")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 250)
                .padding(.top, 50)
            
            Text("Welcome to “عدِّل”!")
                .font(.title)
                .foregroundColor(Color("fontColor"))
                .offset(x: 0, y: 10)
            
            Text("Your smart assistant for detecting bad posters and improving awareness.")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(Color("fontColor"))
                .padding(.top, 1)
                .offset(x: 0, y: 10)
        }
        .padding()
    }
}

struct OnboardingPage2: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("OnBoarding2")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 250)
                .offset(x: 0, y: 90)
            
            Text("We use the camera to analyze your posture with AI, without saving any images. Just a quick analysis to help you improve your sitting position.")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(Color("fontColor"))
                .frame(width: 700)
                .offset(x: 0, y: 90)
        }
        .padding()
    }
}

struct OnboardingPage3: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("OnBoarding3")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 250)
                .offset(x: 0, y: 90)
            
            Text("Stay in the picture!")
                .font(.title)
                .foregroundColor(Color("fontColor"))
                .offset(x: 0, y: 97)
            
            Text("We’ll send you gentle notifications if your sitting posture needs adjustment or when it’s time for a break.")
                .multilineTextAlignment(.center)
                .font(.title2)
                .foregroundColor(Color("fontColor"))
                .frame(width: 500)
                .offset(x: 0, y: 90)
        }
        .padding()
    }
}

struct OnboardingPage4: View {
    var body: some View {
        VStack(spacing: 20) {
            Image("OnBoarding4")
                .resizable()
                .scaledToFit()
                .frame(width: 400, height: 250)
                .offset(x: 0, y: 90)
            
            Text("Maintain a healthy posture!")
                .font(.largeTitle)
                .foregroundColor(Color("fontColor"))
                .offset(x: 0, y: 90)
            
            Text("We’ve prepared simple exercises to help you sit correctly and reduce strain and stress on your body.")
                .multilineTextAlignment(.center)
                .font(.body)
                .foregroundColor(Color("fontColor"))
                .frame(width: 500)
                .offset(x: 0, y: 90)
        }
        .padding()
    }
}


#Preview {
    OnboardingView()
        .frame(minWidth: 1440, minHeight: 900)
}
