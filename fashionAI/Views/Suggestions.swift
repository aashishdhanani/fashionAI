//
//  Suggestions.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/23/24.
//

import SwiftUI

struct Suggestions: View {
    var body: some View {
        ZStack {
            Color.green
            
            Image(systemName: "tshirt")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

#Preview {
    Suggestions()
}
