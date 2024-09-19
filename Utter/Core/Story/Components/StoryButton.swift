//
//  StoryButton.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct StoryButton: View {
    let text: String
    let color: Color
    let action: () -> Void // Closure for the button's action
    
    var body: some View {
        Button(action: {
            action() // Trigger the passed-in action
        }) {
            Text(text)
                .foregroundColor(Color.white)
                .font(.system(size: 24, weight: .bold)) // Larger font size and weight
                .padding()
                .frame(maxWidth: .infinity) // Spread horizontally across the full width
                .background(color)
                .cornerRadius(8.0)
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Adding shadow
        }
    }
}

#Preview {
    StoryButton(text: "Continue", color: Color("ButtonColor"), action: {
        print("Button tapped!")
    })
}
