//
//  fashionAIApp.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/17/24.
//

import SwiftUI
import Firebase

@main
struct fashionAIApp: App {
    @StateObject private var appState = AppStateManager()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if appState.userIsLoggedIn {
                WelcomePage()
                    .environmentObject(appState)
            } else {
                ContentView()
                    .environmentObject(appState)
            }
        }
    }
}
