//
//  PronunciationView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct DynamicWordHighlighter: View {
    let text: String
    @Binding var highlightWords: Set<String>
    
    private func stripPunctuation(_ string: String) -> String {
        return string.lowercased().filter { !$0.isPunctuation }
    }
    
    var body: some View {
        text.split(separator: " ", omittingEmptySubsequences: false)
            .enumerated()
            .reduce(Text("")) { (current, pair) -> Text in
                let (index, substring) = pair
                let word = String(substring)
                let strippedWord = stripPunctuation(word)
                
                let wordText = Text(word)
                    .foregroundColor(highlightWords.contains(strippedWord) ? .green : Color("AccentColor"))
                
                if index == 0 {
                    return wordText
                } else {
                    return current + Text(" ") + wordText
                }
            }
    }
}

struct PronunciationView: View {
    // MARK: - Properties
    let colors: ExerciseColors = ExerciseColors.default
    let exercise: ExerciseOption
    let story: StoryData?
    
    @Binding var showCorrectAnimation: Bool
    @Binding var isExerciseCompleted: Bool
    @Binding var isExpandedAfterCompletion: Bool
    
    @StateObject private var lineViewModel: LineViewModel
    @StateObject private var viewModel = PronunciationViewModel()
    @StateObject private var speechRecognitionManager = SpeechRecognitionManager.shared
    
    // MARK: - Initialization
    init(exercise: ExerciseOption,
         story: StoryData? = nil,
         showCorrectAnimation: Binding<Bool>,
         isExerciseCompleted: Binding<Bool>,
         isExpandedAfterCompletion: Binding<Bool>) {
        self.exercise = exercise
        self.story = story
        self._showCorrectAnimation = showCorrectAnimation
        self._isExerciseCompleted = isExerciseCompleted
        self._isExpandedAfterCompletion = isExpandedAfterCompletion
        self._lineViewModel = StateObject(wrappedValue: LineViewModel(story: story, affectedLine: exercise.affectedLine))
    }
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            textDisplay
            recordButton
//            if isExerciseCompleted {
//                accuracyDisplay
//            }
        }
        .onReceive(viewModel.$isEntireSentenceRecognized) { isRecognized in
                if isRecognized {
                    handleExerciseCompletion()
                }
            }
    }
    
    // MARK: - Subviews
    private var textDisplay: some View {
        HStack {
            if let text = lineViewModel.getLine()?.text {
//                let text = "Detta är ett nytt prov"
                DynamicWordHighlighter(text: text, highlightWords: $viewModel.recognizedWordsSet)
                    .font(.body)
                    .fontWeight(.bold)
//                    .foregroundStyle(colors.accent)
                    .task {
                        viewModel.loadTargetText(targetText: text)
                    }
            } else {
                Text("Could not locate the text.")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundStyle(colors.accent)
            }
            Spacer()
        }
        .cornerRadius(8)
    }
    
//    private var accuracyDisplay: some View {
//        HStack {
//            Spacer()
//            Text("Accuracy: \(viewModel.accuracy * 100, specifier: "%.1f")%")
//                .foregroundColor(viewModel.accuracy > 70 ? .green : Color("TextColor"))
//                .font(.headline)
//                .fontWeight(.bold)
//            Spacer()
//        }
//    }
    
    private var recordButton: some View {
        Button(action: handleRecordButtonTap) {
            Label(buttonLabel, systemImage: buttonIcon)
            Spacer()
        }
        .disabled(!speechRecognitionManager.isAuthorized)
        .allowsHitTesting(!isExerciseCompleted)
        .padding()
        .background(isExerciseCompleted ? Color.gray.opacity(0.1) : colors.accent.opacity(0.1))
        .foregroundColor(speechRecognitionManager.isRecording ? Color.red : (isExerciseCompleted ? Color.gray : colors.accent))
        .cornerRadius(8)
    }
    
    // MARK: - Computed Properties
    private var buttonLabel: String {
        if isExerciseCompleted {
            return "Exercise completed"
        } else if speechRecognitionManager.isRecording {
            return "Press here to stop"
        } else {
            return "Press here to talk"
        }
    }
    
    private var buttonIcon: String {
        speechRecognitionManager.isRecording ? "mic.slash.fill" : "mic.fill"
    }
    
//    private var shouldShowAccuracy: Bool {
//        viewModel.isEntireSentenceRecognized || (!speechRecognitionManager.isRecording && viewModel.accuracy > 0)
//    }
    
    // MARK: - Methods
    private func handleRecordButtonTap() {
        viewModel.toggleRecording()
        
        if !speechRecognitionManager.isRecording {
            if viewModel.accuracy > 0 {
                handleExerciseCompletion()
            }
        }
    }
    
    private func handleExerciseCompletion() {
        speechRecognitionManager.stopRecording()
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

#Preview {
    PronunciationView(exercise: ExerciseOption.sampleCompListen, showCorrectAnimation: .constant(false), isExerciseCompleted: .constant(false), isExpandedAfterCompletion: .constant(false))
}
