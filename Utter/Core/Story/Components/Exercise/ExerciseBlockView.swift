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
    let story: StoryData?
    
    @Binding var displayContinueButton: Bool
    
    @State private var showHints: Bool = false
    @State private var showCorrectAnimation: Bool = false
    @State private var isExerciseCompleted: Bool = false
    @State private var isExpandedAfterCompletion: Bool = false
    
    init(exercise: ExerciseOption, story: StoryData? = nil, displayContinueButton: Binding<Bool>) {
        self.exercise = exercise
        self.colors = ExerciseColors.default
        self.story = story

        self._displayContinueButton = displayContinueButton
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if isExerciseCompleted && !isExpandedAfterCompletion {
                completedExerciseView
            } else {
                exerciseContent
            }
        }
        .onAppear {
            displayContinueButton = false
            Task {
                if let audioPath = exercise.audio {
                    let data = try await StorageManager.shared.getData(path: audioPath)
                    AudioManager.shared.playAudio(data: data)
                }
                
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
                Text("\(exercise.type.displayName)")
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
        .onAppear {
            displayContinueButton = true
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
            
            switch exercise.type {
            case .compMCQ, .compTF, .compListen:
                MultipleChoiceView(exercise: exercise,
                                   showCorrectAnimation: $showCorrectAnimation,
                                   isExerciseCompleted: $isExerciseCompleted,
                                   isExpandedAfterCompletion:$isExpandedAfterCompletion)
            case .pronounceRep, .pronounceDeaf:
                PronunciationView(exercise: exercise, 
                                  story: self.story,
                                  showCorrectAnimation: $showCorrectAnimation,
                                  isExerciseCompleted: $isExerciseCompleted,
                                  isExpandedAfterCompletion: $isExpandedAfterCompletion)
            case .speakReplace, .speakQuestion, .interact:
                SpeakingView(exercise: exercise,
                             story: self.story,
                             showCorrectAnimation: $showCorrectAnimation,
                             isExerciseCompleted: $isExerciseCompleted,
                             isExpandedAfterCompletion: $isExpandedAfterCompletion)
            }
            
            if let hints = exercise.hints, !hints.isEmpty {
                hintsView(hints: hints)
            }
        }
    }
    
    private var exerciseHeader: some View {
        HStack {
            Text("\(exercise.type.displayName)")
                .font(.headline)
                .foregroundColor(colors.text)
            Spacer()
            Text("CEFR: \(exercise.cefr.map { $0.rawValue }.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(colors.text.opacity(0.6))
        }
    }
    
//    private var speakingView: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Button(action: {
//                // Record audio logic here
//            }) {
//                Label("Record Your Answer", systemImage: "mic.fill")
//            }
//            .padding()
//            .background(colors.accent.opacity(0.1))
//            .foregroundColor(colors.accent)
//            .cornerRadius(8)
//            
//            if exercise.type == .speakReplace, let affectedLine = exercise.affectedLine {
//                Text("Affected Line: \(affectedLine)")
//                    .font(.caption)
//                    .foregroundColor(colors.text.opacity(0.6))
//            }
//        }
//    }
    
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
            ExerciseBlockView(exercise: ExerciseOption.sampleMCQ, displayContinueButton: .constant(false))
        }
        .padding()
    }
    .background(Color("AppBackgroundColor"))
}
