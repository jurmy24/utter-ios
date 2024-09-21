//
//  SpeakingView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct SpeakingView: View {
    private let speechRecognitionManager: SpeechRecognitionManager = SpeechRecognitionManager.shared
    let colors: ExerciseColors = ExerciseColors.default
    let exercise: ExerciseOption
    let story: StoryData?
    @Binding var showCorrectAnimation: Bool
    @Binding var isExerciseCompleted: Bool
    @Binding var isExpandedAfterCompletion: Bool
    @StateObject private var viewModel: LineViewModel
    @State private var transcribedText: String = ""
    @State private var isInteractive: Bool = false
    private var processedStory: String = ""
    
    init(exercise: ExerciseOption,
         story: StoryData? = nil,
         showCorrectAnimation: Binding<Bool>,
         isExerciseCompleted: Binding<Bool>,
         isExpandedAfterCompletion: Binding<Bool>
    ) {
        self.exercise = exercise
        self.story = story
        self._showCorrectAnimation = showCorrectAnimation
        self._isExerciseCompleted = isExerciseCompleted
        self._isExpandedAfterCompletion = isExpandedAfterCompletion
        self._viewModel = StateObject(wrappedValue: LineViewModel(story: story, affectedLine: exercise.affectedLine))
        self.processedStory = "" // TODO: create a function to retrieve the story we have processed so far
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            let (labelText, image) = labelTextAndImage(for: exercise.type)
            
            if let query = exercise.query {
                Text(query)
                    .font(.body)
                    .foregroundColor(colors.text)
            }
            
            if exercise.type == .speakQuestion || exercise.type == .speakReplace {
                HStack {
                    Text(transcribedText)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundStyle(colors.accent)
                    Spacer()
                }
            }
            
            HStack {
                Button(action: exercise.type != .interact ? handleRecordButtonTap : handleLiveInteraction) {
                    Label(labelText, systemImage: image)
                    Spacer()
                }
                .disabled(!speechRecognitionManager.isAuthorized)
                .allowsHitTesting(!isExerciseCompleted)
                Spacer()
            }
            .padding()
            .background(isExerciseCompleted ? Color.gray.opacity(0.1) : colors.accent.opacity(0.1))
            .foregroundColor(speechRecognitionManager.isRecording ? Color.red : (isExerciseCompleted ? Color.gray : colors.accent))
            .cornerRadius(8)
        }
        .fullScreenCover(isPresented: $isInteractive , onDismiss: endSession) {
            if let query = exercise.query {
                NavigationStack{
                    LiveInteractionView(isInteractive: $isInteractive, firstMessage: query, extraContext: self.processedStory)
                }
            } else {
                LiveInteractionView(isInteractive: $isInteractive, firstMessage: "", extraContext: "")
                    .onAppear {
                        print("Issue")
                        isInteractive = false
                    }
            }
        }
    }
    
    // MARK: - Methods
    private func handleRecordButtonTap() {
        if !speechRecognitionManager.isRecording {
            Task {
                try speechRecognitionManager.startRecording()
            }
        } else {
            transcribedText = speechRecognitionManager.transcribedText
            speechRecognitionManager.stopRecording()
            endSession()
        }
    }
    
    private func endSession() {
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
    
    private func handleLiveInteraction() {
        isInteractive = true
    }
    
    // Helper function to get the label text and image based on exercise type
    private func labelTextAndImage(for type: ExerciseType) -> (String, String) {
        switch type {
        case .speakReplace:
            if let character = viewModel.getLine()?.character {
                return ("Press to speak for \(character)", "mic.fill")
            } else {
                return ("Press to speak", "mic.fill")
            }
        case .speakQuestion:
            return ("Press to speak", "mic.fill")
        case .interact:
            return ("Press to enter a live interaction", "waveform")
        default:
            return ("This is not a valid exercise type", "xmark.octagon")
        }
    }
}

#Preview {
    SpeakingView(exercise: ExerciseOption.sampleInteract, showCorrectAnimation: .constant(false), isExerciseCompleted: .constant(false), isExpandedAfterCompletion: .constant(false))
}
