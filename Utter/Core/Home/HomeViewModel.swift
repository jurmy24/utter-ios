//
//  HomeViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var stories: [DBStory] = []
    @Published var selectedLanguage: StoryLanguage? = nil
    private var lastDocument: DocumentSnapshot? = nil
    
    // Define the Constants inside the class
    let blobSize: CGFloat = 100
    let verticalSpacingMultiplier: CGFloat = 0.9
    let initialYOffset: CGFloat = 0.95
    let extraContentHeight: CGFloat = 200
    let horizontalMarginFactor: CGFloat = 1.8
    
    // Define variables dependent on the number of stories
    var numberOfBlobs: Int {
        stories.count
    }
    var contentHeight: CGFloat {
        let blobHeightWithSpacing = blobSize + (blobSize * verticalSpacingMultiplier)
        return CGFloat(max(numberOfBlobs, 1)) * blobHeightWithSpacing + extraContentHeight
    }
    
    func getStoriesForLanguage(language: StoryLanguage) async throws {
        switch language {
        case .english:
            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .english)
        case .french:
            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .french)
        case .swedish:
            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .swedish)
        }
        self.selectedLanguage = language
    }
    
    /* In case I end up with a shit ton of stories and want to load them as I scroll upwards */
    //    func getStoriesForLanguageLimited(language: StoryLanguage) async throws {
    //        let (newStories, lastDocument) = try await StoryManager.shared.getAllStoriesByLanguage(language: language, count: 5, lastDocument: lastDocument)
    //        self.stories.append(contentsOf:newStories)
    //        self.selectedLanguage = language
    //        self.lastDocument = lastDocument
    //    }
    
    init(selectedLanguage: StoryLanguage) {
        self.selectedLanguage = selectedLanguage
        Task {
            await self.loadStories()
        }
    }
    
    private func loadStories() async {
        guard let language = self.selectedLanguage else { return }
        do {
            try await getStoriesForLanguage(language: language)
        } catch {
            print("Error loading stories: \(error)")
        }
    }
    
}

// Generate blob positions extension
extension HomeViewModel {
    
    // Generate random horizontal positions and equally spaced vertical positions (relative)
    func generateBlobPositions() -> [CGPoint] {
        // Define the size of the StoryBlob and the vertical spacing multiplier
        let screenWidth = UIScreen.main.bounds.width
        let margin = blobSize / 1.8 / screenWidth
        let positions = (0..<numberOfBlobs).map { index in
            let normalizedX = (sin(CGFloat(index)) + 1) / 2
            let constrainedX = margin + normalizedX * (1 - 2 * margin)
            
            return CGPoint(
                x: constrainedX,
                y: CGFloat(0.95) - (CGFloat(index) * (blobSize + blobSize * verticalSpacingMultiplier) / contentHeight)
            )
        }
        return positions
    }
    
}
