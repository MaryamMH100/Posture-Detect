//
//  HomeView.swift
//  PostureDetect
//
//  Created by Reema ALhudaian on 10/09/1446 AH.
//
//
//import SwiftData
//import SwiftUI
//
//struct HomeView: View {
//    @State private var showPreferences = false
//    @Query private var preferences: [UserPreferences]
//    @Environment(\.modelContext) private var modelContext
//
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
//     @AppStorage("hasCompletedPreferences") private var hasCompletedPreferences = false
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("🏡 مرحبًا بك في الصفحة الرئيسية!")
//                    .font(.largeTitle)
//                    .bold()
//
//                // زر تعديل الإعدادات
//                Button(action: {
//                    showPreferences = true
//                }) {
//                    Text("⚙️ تعديل الإعدادات")
//                        .bold()
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal, 40)
//                .sheet(isPresented: $showPreferences) {
//                    PreferencesView(isOnboarding: !hasCompletedOnboarding) // فتح شيت الإعدادات
//                }
//            }
//            .padding()
//            .onAppear {
//                loadPreferences() // تحميل الإعدادات عند ظهور الصفحة
//            }
//        }
//    }
//
//    private func loadPreferences() {
//        if preferences.isEmpty {
//            let startTime = UserDefaults.standard.string(forKey: "startTime") ?? "9:00 AM"
//            let endTime = UserDefaults.standard.string(forKey: "endTime") ?? "5:00 PM"
//            let notificationFrequency = UserDefaults.standard.string(forKey: "notificationFrequency") ?? "Once"
//            let isExerciseEnabled = UserDefaults.standard.bool(forKey: "isExerciseEnabled")
//            let isBreakEnabled = UserDefaults.standard.bool(forKey: "isBreakEnabled")
//            
//            let newPreferences = UserPreferences(
//                startTime: startTime,
//                endTime: endTime,
//                notificationFrequency: notificationFrequency,
//                isExerciseEnabled: isExerciseEnabled,
//                isBreakEnabled: isBreakEnabled
//            )
//            modelContext.insert(newPreferences) // إضافة الإعدادات الجديدة إلى modelContext
//        }
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
