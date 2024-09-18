//
//  ContinueWithGoogle.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-09.
//

import SwiftUI

struct ContinueWithGoogle: View {
    
    
    var body: some View {
        HStack{
            Image("Google")
                .resizable()
                .scaledToFit()
                .frame(width:30, height:30)
            Text("Continue with Google")
                .font(.title3)
                .foregroundColor(Color.black)
        }
        .frame(height:55)
        .frame(maxWidth:.infinity)
        .background(Color.white)
        .cornerRadius(8)
        .overlay(
                    RoundedRectangle(cornerRadius: 8) // Matching radius for the border
                        .stroke(Color.black, lineWidth: 1) // Blue border with width 2
                )
    }
}

#Preview {
    ContinueWithGoogle()
}
