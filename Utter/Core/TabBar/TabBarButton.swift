//
//  TabBarButton.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-12.
//

import SwiftUI

struct TabBarButton: View {
    
    var buttonText: String
    var imageName: String
    var isActive: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            if isActive {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(.accentColor)
                    .frame(height: 6)
                    .padding(.top, 3)
                    .padding(.horizontal, 15)
            } else {
                // Placeholder to maintain spacing when not active
                Color.clear
                    .frame(height: 9)
            }
            
            Spacer()
            
            VStack (alignment: .center, spacing: 4) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: 35, height: 35)
                
                Text(buttonText)
                    .font(.caption)
                    .foregroundColor(.accentColor)
            }
            
            Spacer()
        }
        .padding(.bottom, 10)
    }
}


#Preview {
    TabBarButton(buttonText: "Language", imageName: "flag.fill", isActive: true)
}
