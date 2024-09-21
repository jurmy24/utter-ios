//
//  MultipleChoiceView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI


struct MultipleChoiceView: View {
    let exercise: ExerciseOption
    @State var selectedAnswers: [String] = []
    @Binding var showCorrectAnimation: Bool
    @Binding var isExerciseCompleted: Bool
    @Binding var isExpandedAfterCompletion: Bool
    let colors: ExerciseColors = ExerciseColors.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let query = exercise.query {
                Text(query)
                    .font(.body)
                    .foregroundColor(colors.text)
            } else if exercise.type == .compListen {
                Text("Select what you heard.")
                    .font(.body)
                    .foregroundColor(colors.text)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                
                if let answerOptions = exercise.answerOptions {
                    ForEach(Array(answerOptions.keys), id: \.self) { key in
                        if let option = answerOptions[key] {
                            Button(action: {
                                if !selectedAnswers.contains(key) {
                                    selectedAnswers.append(key)

                                    if option.isCorrect {
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
                                    }
                                }
                            }) {
                                HStack {
                                    Text(option.text)
                                    Spacer()
                                    if selectedAnswers.contains(key) {
                                        Image(systemName: option.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .foregroundColor(option.isCorrect ? colors.correctAnswer : colors.wrongAnswer)
                                    }
                                }
                                .padding()
                                .background(backgroundColor(for: key, isCorrect: option.isCorrect))
                                .foregroundColor(foregroundColor(for: key, isCorrect: option.isCorrect))
                                .cornerRadius(8)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .disabled(selectedAnswers.contains(where: { answerOptions[$0]?.isCorrect == true }))
                        }
                    }
                }
            }
        }
    }
    
    
    private func backgroundColor(for key: String, isCorrect: Bool) -> Color {
        return selectedAnswers.contains(key) ?
        (isCorrect ? colors.correctAnswer.opacity(0.2) : colors.wrongAnswer.opacity(0.2)) :
        colors.buttonBackground
    }
    
    private func foregroundColor(for key: String, isCorrect: Bool) -> Color {
        if selectedAnswers.contains(key) {
            return isCorrect ? colors.correctAnswer : colors.wrongAnswer
        }
        return colors.buttonText
    }
}

#Preview {
    MultipleChoiceView(exercise: ExerciseOption.sampleMCQ, showCorrectAnimation: .constant(false), isExerciseCompleted: .constant(true), isExpandedAfterCompletion: .constant(true))
}
