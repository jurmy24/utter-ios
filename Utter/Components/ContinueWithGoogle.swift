//
//  ContinueWithGoogle.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-09.
//

import SwiftUI

struct ContinueWithGoogle: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack{
            Image("Google")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
            Text("Continue with Google")
                .font(.title3)
                .foregroundColor(Color.primary)
        }
        .frame(height:55)
        .frame(maxWidth:.infinity)
        .background(colorScheme == .dark ? Color.blue : Color.white)
        .cornerRadius(10)
        .overlay(
                    RoundedRectangle(cornerRadius: 10) // Matching radius for the border
                        .stroke(Color.secondary, lineWidth: 1) // Blue border with width 2
                )
    }
}

#Preview {
    ContinueWithGoogle()
}
