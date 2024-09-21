////
////  TestVoiceTranscriptionView.swift
////  Utter
////
////  Created by Victor Magnus Oldensand on 2024-09-21.
////
//
//import SwiftUI
//
////struct DynamicWordHighlighter: View {
////    let text: String
////    @Binding var highlightWords: Set<String>
////    
////    private func stripPunctuation(_ string: String) -> String {
////        return string.lowercased().filter { !$0.isPunctuation }
////    }
////    
////    var body: some View {
////        text.split(separator: " ", omittingEmptySubsequences: false)
////            .enumerated()
////            .reduce(Text("")) { (current, pair) -> Text in
////                let (index, substring) = pair
////                let word = String(substring)
////                let strippedWord = stripPunctuation(word)
////                
////                let wordText = Text(word)
////                    .foregroundColor(highlightWords.contains(strippedWord) ? .green : .primary)
////                
////                if index == 0 {
////                    return wordText
////                } else {
////                    return current + Text(" ") + wordText
////                }
////            }
////    }
////}
//
////struct ContentView: View {
////    @State private var fullText = "The quick brown fox jumps over the lazy dog"
////    @State private var highlightWords: Set<String> = ["quick", "fox"]
////    
////    var body: some View {
////        VStack {
////            DynamicWordHighlighter(text: fullText, highlightWords: $highlightWords)
////            
////            Button("Update Highlights") {
////                // Simulate updating the highlight words
////                highlightWords = Set(["brown", "lazy"])
////            }
////        }
////    }
////}
//
////struct TestVoiceTranscriptionView: View {
////    @StateObject private var viewModel: PronunciationViewModel
////    @StateObject var speechRecognitionManager = SpeechRecognitionManager.shared
////    
////    // Initialize the ViewModel with the target text from the View
////    init(targetText: String) {
////        self._viewModel = StateObject(wrappedValue: PronunciationViewModel(targetText: targetText))
////    }
//    
//    var body: some View {
//        VStack {
//            Text("Target Text:")
////            Text(viewModel.targetText)
//            DynamicWordHighlighter(text: viewModel.targetText, highlightWords: $viewModel.recognizedWordsSet)
//                .font(.headline)
//            Text("Transcribed Text:")
//            Text(speechRecognitionManager.transcribedText)
//                .font(.subheadline)
//                .padding()
//            
//            Text("Accuracy: \(viewModel.accuracy)")
//            Text("Recognized words: \(viewModel.recognizedWordsSet)")
//            
//            // Record/Stop Button
//            Button(action: {
//                viewModel.toggleRecording()
//            }) {
//                Text(speechRecognitionManager.isRecording ? "Stop Recording" : "Start Recording")
//                    .foregroundColor(.white)
//                    .padding()
//                    .background(speechRecognitionManager.isRecording ? Color.red : Color.blue)
//                    .cornerRadius(8)
//            }
//            .disabled(!speechRecognitionManager.isAuthorized)
//            .padding()
//            
//            if viewModel.isEntireSentenceRecognized {
//                Text("You pronounced the entire sentence correctly!")
//                    .foregroundColor(.green)
//                    .font(.headline)
//                    .padding()
//            }
//            
//            // If authorization is not granted, show a message
//            if !speechRecognitionManager.isAuthorized {
//                Text("Speech recognition is not authorized.")
//                    .foregroundColor(.red)
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    TestVoiceTranscriptionView(targetText: "Hej, jag heter Viktor och jag kommer ifrån Sverige.")
////    ContentView()
//}
