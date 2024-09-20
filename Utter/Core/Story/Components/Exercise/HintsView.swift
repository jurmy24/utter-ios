//
//  HintsView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct HintsView: View {
    let hints: [String]
    @Binding var showHints: Bool
    let colors: ExerciseColors
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: {
                showHints.toggle()
            }) {
                Label(showHints ? "Hide Hints" : "Show Hints", systemImage: showHints ? "eye.slash" : "eye")
            }
            .padding(.vertical, 4)
            .foregroundColor(colors.accent)
            
            if showHints {
                ForEach(hints, id: \.self) { hint in
                    Text("• \(hint)")
                        .font(.caption)
                        .foregroundColor(colors.text.opacity(0.6))
                }
            }
        }
    }
}


//#Preview {
//    HintsView()
//}
