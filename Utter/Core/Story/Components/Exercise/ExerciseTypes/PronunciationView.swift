//
//  PronunciationView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct PronunciationView: View {
    let colors: ExerciseColors = ExerciseColors.default
    let exercise: ExerciseOption
    @Binding var showCorrectAnimation: Bool
    @Binding var isExerciseCompleted: Bool
    @Binding var isExpandedAfterCompletion: Bool
    
    var body: some View {
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    // TODO: fetch this from the correct place based on the affectedLine
                    Text("This is the text that should be read aloud.")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(colors.accent)
                    Spacer()
                    
                    // TODO: Add ifMostlyCorrect or something to change the view
//                    if selectedAnswers.contains(key) {
//                        Image(systemName: option.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
//                            .foregroundColor(option.isCorrect ? colors.correctAnswer : colors.wrongAnswer)
//                    }
                }
                .cornerRadius(8)
                
                HStack {
                    Button(action: {
                        // Record audio logic here
                        withAnimation {
                            showCorrectAnimation = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation {
                                showCorrectAnimation = false
                                isExerciseCompleted = true
                                isExpandedAfterCompletion = false
                            }
                        }
                    }) {
                        Label("Press here to talk", systemImage: "mic.fill")
                    }
                    .allowsHitTesting(isExerciseCompleted ? false : true)

                    Spacer()
                }
                .padding()
                .background(isExerciseCompleted ? Color.gray.opacity(0.1) : colors.accent.opacity(0.1))
                .foregroundColor(isExerciseCompleted ? Color.gray : colors.accent)
                .cornerRadius(8)
                
            }
        
    }
}

#Preview {
    PronunciationView(exercise: ExerciseOption.sampleCompListen, showCorrectAnimation: .constant(false), isExerciseCompleted: .constant(false), isExpandedAfterCompletion: .constant(false))
}
