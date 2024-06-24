//
//  Profile.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/23/24.
//

import SwiftUI

struct Profile: View {
    @EnvironmentObject var appState: AppStateManager
    @Binding var userIsLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red
                
                VStack {
                    Spacer()
                    
                    Image(systemName: "person")
                        .foregroundColor(Color.white)
                        .font(.system(size: 100))
                    
                    Spacer()
                    
                    Button("Logout") {
                        appState.signOut()
                    }
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.bottom, 50)
                }
            }
            
        }
    }
}

#Preview {
    Profile(userIsLoggedIn: .constant(true))
}
