//
//  ListView.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/17/24.
//

import SwiftUI
import Firebase

struct WelcomePage: View {
    
    @State private var showWelcomePopup = true
    @State private var showContent = false  // New state variable
    
    
    var body: some View {
        ZStack {
            // Background
            Color.white.edgesIgnoringSafeArea(.all)
            
            // Content (only shown after "Get Started" is clicked)
            if showContent {
                VStack {
                    HomePage()
                }
            }
            
            // Welcome popup
            if showWelcomePopup {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        WelcomePopupView(isPresented: $showWelcomePopup, onGetStarted: {
                            showContent = true  // Show content when "Get Started" is clicked
                        })
                    )
            }
        }
    }
}

struct WelcomePopupView: View {
    @EnvironmentObject var appState: AppStateManager
    @Binding var isPresented: Bool
    var onGetStarted: () -> Void
    
    var body: some View {
        VStack {
            Text("Welcome to FashionAI!")
                .font(.title)
                .padding()
            
            Text("Use AI to upgrade your fashion sense! Click below to begin!")
                .padding()
                .multilineTextAlignment(.center)
            
            Button("Get Started") {
                onGetStarted()  // Call the closure when "Get Started" is tapped
                isPresented = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    WelcomePage()
}
