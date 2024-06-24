//
//  Camera.swift
//  fashionAI
//
//  Created by Aashish Dhanani on 6/23/24.
//

import SwiftUI

struct Camera: View {
    var body: some View {
        ZStack {
            Color.blue
            
            Image(systemName: "camera")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

#Preview {
    Camera()
}
