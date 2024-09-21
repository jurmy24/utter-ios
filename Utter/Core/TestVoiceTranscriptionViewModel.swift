//
//  TestVoiceTranscriptionViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-21.
//

import Foundation
import Combine

@MainActor
final class TestVoiceTranscriptionViewModel: ObservableObject {
    private let speechRecognitionManager: SpeechRecognitionManager = SpeechRecognitionManager.shared
    let targetText: String
    var targetTextSet: Set<String> = []
    @Published var recognizedWordsSet: Set<String> = []
    @Published var accuracy: Float = 0
    @Published var isEntireSentenceRecognized: Bool = false
    
    private var cancellables = Set<AnyCancellable>() // For Combine
    
    init(targetText: String) {
        self.targetText = targetText
        self.targetTextSet = Set(preprocessText(targetText))
        
        // Observe changes in the transcribed text from the SpeechRecognitionManager
        speechRecognitionManager.$transcribedText
            .sink { [weak self] _ in
                self?.updateRecognizedWords() // Call update whenever transcribedText changes
            }
            .store(in: &cancellables)
    }
    
    func toggleRecording() {
        if speechRecognitionManager.isRecording {
            speechRecognitionManager.stopRecording()
            updateRecognizedWords()
        } else {
            do {
                try speechRecognitionManager.startRecording()
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateRecognizedWords() {
        let transcribedTextSet = Set(preprocessText(speechRecognitionManager.transcribedText))

        recognizedWordsSet = targetTextSet.filter { targetWord in
            transcribedTextSet.contains { transcribedWord in
                let distance = levenshteinDistance(transcribedWord, targetWord)
                
                // Apply different thresholds for short and long words
                if targetWord.count <= 3 {
                    return distance == 0 // Exact match for words with 3 letters or fewer
                } else if targetWord.count <= 4 {
                    return distance <= 1 // Allow 1 difference for 4-letter words
                } else {
                    return distance <= 2 // Allow 2 differences for longer words
                }
            }
        }
        accuracy = Float(recognizedWordsSet.count) / Float(targetTextSet.count)
        isEntireSentenceRecognized = recognizedWordsSet == targetTextSet
    }
    
    // A function to compute Levenshtein distance
    private func levenshteinDistance(_ s1: String, _ s2: String) -> Int {
        let empty = [Int](repeating: 0, count: s2.count)
        var last = [Int](0...s2.count)
        
        for (i, tL) in s1.enumerated() {
            var cur = [i + 1] + empty
            for (j, tR) in s2.enumerated() {
                cur[j + 1] = tL == tR ? last[j] : Swift.min(last[j], last[j + 1], cur[j]) + 1
            }
            last = cur
        }
        return last.last!
    }
    
    private func preprocessText(_ text: String) -> [String] {
        let preprocessedText = text.lowercased()
            .components(separatedBy: .punctuationCharacters).joined()
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        return preprocessedText
        
    }
}
