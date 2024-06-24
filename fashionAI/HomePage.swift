//
//  HomePage.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/23/24.
//

import SwiftUI

struct HomePage: View {
    @State private var userIsLoggedIn = true
    var body: some View {
        TabView {
            Profile(userIsLoggedIn: $userIsLoggedIn)
                .tabItem() {
                    Image(systemName: "person")
                    Text("Profile")
                }
            Camera()
                .tabItem() {
                    Image(systemName: "camera")
                    Text("Camera")
                }
            Suggestions()
                .tabItem() {
                    Image(systemName: "tshirt")
                    Text("Suggestions")
                }
        }
    }
}

#Preview {
    HomePage()
}
