//
//  ExerciseCompletionView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct ExerciseCompletionView: View {
    let exercise: ExerciseOption
    let colors: ExerciseColors
    @Binding var isExpanded: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(colors.correctAnswer)
                .font(.largeTitle)
            
            VStack(alignment: .leading) {
                Text("Exercise Completed")
                    .font(.headline)
                    .foregroundColor(colors.text)
                
                Text("CEFR: \(exercise.cefr.map { $0.rawValue }.joined(separator: ", "))")
                    .font(.subheadline)
                    .foregroundColor(colors.text.opacity(0.6))
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .foregroundColor(colors.accent)
                    .font(.title2)
            }
        }
    }
}


//#Preview {
//    ExerciseCompletionView()
//}
