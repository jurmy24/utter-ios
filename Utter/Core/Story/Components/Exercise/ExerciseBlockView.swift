//
//  ExerciseBlockView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct ExerciseColors {
    let background: Color
    let text: Color
    let accent: Color
    let buttonBackground: Color
    let buttonText: Color
    let correctAnswer: Color
    let wrongAnswer: Color
    
    static let `default` = ExerciseColors(
        background: Color("FieldBackground"),
        text: Color("TextColor"),
        accent: Color("AccentColor"),
        buttonBackground: Color("ReverseAccent"),
        buttonText: Color("TextColor"),
        correctAnswer: .green,
        wrongAnswer: .red
    )
}

struct ExerciseBlockView: View {
    let exercise: ExerciseOption
    let colors: ExerciseColors
    
    @State private var selectedAnswers: [String] = []
    @State private var showHints: Bool = false
    @State private var showCorrectAnimation: Bool = false
    @State private var isExerciseCompleted: Bool = false
    @State private var isExpandedAfterCompletion: Bool = false
    
    init(exercise: ExerciseOption) {
        self.exercise = exercise
        self.colors = ExerciseColors.default
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isExerciseCompleted && !isExpandedAfterCompletion {
                completedExerciseView
            } else {
                exerciseContent
            }
        }
        .padding()
        .background(colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(colors.accent, lineWidth: 2) // Add the border with rounded corners
        )
        .overlay(
            Group {
                if showCorrectAnimation {
                    Color.green.opacity(0.3)
                        .overlay(
                            Image(systemName: "checkmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 100)
                        )
                        .transition(.opacity)
                }
            }
        )
        .animation(.easeInOut, value: showCorrectAnimation)
        .animation(.easeInOut, value: isExerciseCompleted)
        .animation(.easeInOut, value: isExpandedAfterCompletion)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
    
    private var completedExerciseView: some View {
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
                withAnimation{
                    isExpandedAfterCompletion.toggle()
                }
            }) {
                Image(systemName: isExpandedAfterCompletion ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                    .foregroundColor(colors.accent)
                    .font(.title2)
            }
        }
    }
    
    private var exerciseContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                exerciseHeader
                
                if isExerciseCompleted {
                    Spacer()
                    Button(action: {
                        withAnimation{
                            isExpandedAfterCompletion.toggle()
                        }
                    }) {
                        Image(systemName: "chevron.up.circle.fill")
                            .foregroundColor(colors.accent)
                            .font(.title2)
                    }
                }
            }
            
            if let query = exercise.query {
                Text(query)
                    .font(.body)
                    .foregroundColor(colors.text)
            }
            
            switch exercise.type {
            case .compMCQ, .compTF:
                multipleChoiceView
            case .compListen:
                listeningComprehensionView
            case .pronounceRep, .pronounceDeaf:
                pronunciationView
            case .speakReplace, .speakQuestion, .interact:
                speakingView
            }
            
            if let hints = exercise.hints, !hints.isEmpty {
                hintsView(hints: hints)
            }
        }
    }
    
    private var exerciseHeader: some View {
        HStack {
            Text("Exercise")
                .font(.headline)
                .foregroundColor(colors.text)
            Spacer()
            Text("CEFR: \(exercise.cefr.map { $0.rawValue }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(colors.text.opacity(0.6))
        }
    }
    
    private var multipleChoiceView: some View {
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
    
    
    
    private func backgroundColor(for key: String, isCorrect: Bool) -> Color {
        if selectedAnswers.contains(key) {
            return isCorrect ? colors.correctAnswer.opacity(0.2) : colors.wrongAnswer.opacity(0.2)
        }
        return colors.buttonBackground
    }
    
    private func foregroundColor(for key: String, isCorrect: Bool) -> Color {
        if selectedAnswers.contains(key) {
            return isCorrect ? colors.correctAnswer : colors.wrongAnswer
        }
        return colors.buttonText
    }
    
    private var listeningComprehensionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let audio = exercise.audio {
                Button(action: {
                    // Play audio logic here
                }) {
                    Label("Play Audio", systemImage: "play.circle.fill")
                }
                .padding()
                .background(colors.accent.opacity(0.1))
                .foregroundColor(colors.accent)
                .cornerRadius(8)
            }
            multipleChoiceView
        }
    }
    
    private var pronunciationView: some View {
        VStack(alignment: .leading, spacing: 8) {
            if exercise.type == .pronounceRep, let audio = exercise.audio {
                Button(action: {
                    // Play audio logic here
                }) {
                    Label("Listen and Repeat", systemImage: "play.circle.fill")
                }
                .padding()
                .background(colors.accent.opacity(0.1))
                .foregroundColor(colors.accent)
                .cornerRadius(8)
            }
            
            Button(action: {
                // Record audio logic here
            }) {
                Label("Record Your Pronunciation", systemImage: "mic.fill")
            }
            .padding()
            .background(colors.accent.opacity(0.1))
            .foregroundColor(colors.accent)
            .cornerRadius(8)
        }
    }
    
    private var speakingView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                // Record audio logic here
            }) {
                Label("Record Your Answer", systemImage: "mic.fill")
            }
            .padding()
            .background(colors.accent.opacity(0.1))
            .foregroundColor(colors.accent)
            .cornerRadius(8)
            
            if exercise.type == .speakReplace, let affectedLine = exercise.affectedLine {
                Text("Affected Line: \(affectedLine)")
                    .font(.caption)
                    .foregroundColor(colors.text.opacity(0.6))
            }
        }
    }
    
    private func hintsView(hints: [String]) -> some View {
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

#Preview{
    ScrollView {
        Group {
            ExerciseBlockView(exercise: ExerciseOption.sampleMCQ)
            
            

        }
        .padding()
    }
    .background(Color("AppBackgroundColor"))
}
