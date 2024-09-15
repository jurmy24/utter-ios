//
//  HomeViewModel.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-13.
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published private(set) var stories: [DBStory] = []
    @Published var selectedLanguage: StoryLanguage? = nil
    
    // Number of StoryBlobs
    var numberOfBlobs: Int {
        return stories.count
    }
    
    // Define the size of the StoryBlob and the vertical spacing multiplier
    let blobSize: CGFloat = 100
    let verticalSpacingMultiplier: CGFloat = 0.9
    
//    let contentHeight: CGFloat = 2000
    var contentHeight: CGFloat {
        let blobHeightWithSpacing = blobSize + (blobSize * verticalSpacingMultiplier)
        return CGFloat(numberOfBlobs) * blobHeightWithSpacing + 200
    }
    
    let screenWidth = UIScreen.main.bounds.width
    
    // Generate random horizontal positions and equally spaced vertical positions (relative)
    func generateBlobPositions() -> [CGPoint] {
        print(numberOfBlobs)
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
