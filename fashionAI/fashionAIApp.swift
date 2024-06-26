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
    @StateObject private var photoManger = PhotoManager()
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if appState.userIsLoggedIn {
                WelcomePage()
                    .environmentObject(appState)
                    .environmentObject(photoManger)
            } else {
                ContentView()
                    .environmentObject(appState)
                    .environmentObject(photoManger)
            }
        }
    }
}
