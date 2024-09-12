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
        GeometryReader { geo in
            if isActive {
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(.accentColor)
                    .frame(width: geo.size.width/2, height:6)
                    .padding(.leading, geo.size.width/4)
                    .padding(.top, 3)
            }
            
            VStack (alignment: .center, spacing: 4) {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.accentColor)
                    .frame(width: 35, height: 35) // Make it a circular button
                
                Text(buttonText)
                    .font(.caption)
                    .foregroundColor(Color.black)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}

#Preview {
    TabBarButton(buttonText: "Language", imageName: "flag.fill", isActive: true)
}
