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
    
//    @Published private(set) var stories: [DBStory] = []
    @Published private(set) var storiesWithProgress: [StoryWithProgress] = []
    @Published var selectedLanguage: Language? = nil
    //    private var lastDocument: DocumentSnapshot? = nil
    
    // Define the Constants inside the class
    let blobSize: CGFloat = 100
    let verticalSpacingMultiplier: CGFloat = 0.9
    let initialYOffset: CGFloat = 0.95
    let extraContentHeight: CGFloat = 200
    let horizontalMarginFactor: CGFloat = 1.8
    
    // Define variables dependent on the number of stories
    var numberOfBlobs: Int {
        storiesWithProgress.count
    }
    var contentHeight: CGFloat {
        let blobHeightWithSpacing = blobSize + (blobSize * verticalSpacingMultiplier)
        return CGFloat(max(numberOfBlobs, 1)) * blobHeightWithSpacing + extraContentHeight
    }
    
    init(selectedLanguage: Language) {
        self.selectedLanguage = selectedLanguage
        Task {
            await self.loadStoriesWithProgress()
        }
    }
    
//    private func loadStories() async {
//        guard let language = self.selectedLanguage else { return }
//        do {
//            try await getStoriesForLanguage(language: language)
//        } catch {
//            print("Error loading stories: \(error)")
//        }
//    }
    
    func loadStoriesWithProgress() async {
        guard let selectedLanguage = self.selectedLanguage else { return }
        do {
            // Fetch stories and user progress
            let dbStories = try await StoryManager.shared.getAllStoriesByLanguage(language: selectedLanguage)
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userStories = try await UserManager.shared.getUserLanguageStories(userId: authDataResult.uid, language: selectedLanguage)
            
            // Use LevelManager to merge data
            self.storiesWithProgress = LevelManager.shared.mergeStoriesWithProgress(dbStories: dbStories, userStories: userStories)
        } catch {
            print("Error loading stories with progress: \(error)")
        }
    }
    
//    func getStoriesForLanguage(language: Language) async throws {
//        let authDataResponse = try AuthenticationManager.shared.getAuthenticatedUser()
//        
//        switch language {
//        case .english:
//            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .english)
//        case .french:
//            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .french)
//        case .swedish:
//            self.stories = try await StoryManager.shared.getAllStoriesByLanguage(language: .swedish)
//            let test = try await UserManager.shared.getUserLanguageStories(userId: authDataResponse.uid, language: .swedish)
//            print(test)
//        }
//        self.selectedLanguage = language
//    }
    
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
