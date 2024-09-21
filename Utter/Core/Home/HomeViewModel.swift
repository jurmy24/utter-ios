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
        
    static let shared = HomeViewModel(selectedLanguage: .swedish) // TODO: this is for now
    
    @Published private(set) var stories: [Story] = []
    @Published var selectedLanguage: Language? = nil
    
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
    
    init(selectedLanguage: Language) {
        self.selectedLanguage = selectedLanguage
        Task {
            await self.loadStories()
        }
    }
    
    func loadStories() async {
        //        guard let selectedLanguage = self.selectedLanguage else { return }
        //        let call = await firebaseStoryService.loadStories(selectedLanguage: selectedLanguage)
        //        self.stories = getStories(dbStories: call.0, userProgresses: call.1)
        guard let selectedLanguage = self.selectedLanguage else { return }
        do {
            // Fetch stories and user progress
            let dbStories = try await StoryManager.shared.getAllStoriesByLanguage(language: selectedLanguage)
            let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
            let userProgresses = try await UserManager.shared.getUserLanguageStories(userId: authDataResult.uid, language: selectedLanguage)
            
            // Combine the stories with user progress
            self.stories = getStories(dbStories: dbStories, userProgresses: userProgresses)
        } catch {
            print("Error loading stories with progress: \(error)")
        }
    }
    
    private func getStories(dbStories: [DBStory], userProgresses: [UserStoryProgress]) -> [Story] {
        // Create a dictionary for quick lookup of user progress by story ID
        let userStoriesDict = Dictionary(uniqueKeysWithValues: userProgresses.map { ($0.storyId, $0) })
        
        // dbStories are already sorted as per the firestore fetch
        let sortedStories = dbStories
        
        var isPreviousStoryComplete = true
        var storyModels: [Story] = []
        
        for story in sortedStories {
            let userProgress = userStoriesDict[story.id] // returns nil if not present
            let isLocked = !isPreviousStoryComplete // TODO: might be better to set to true when userProgress is nil
            
            // Create the StoryModel using the static method
            let storyModel = Story.create(from: story, userProgress: userProgress, isLocked: isLocked)
            storyModels.append(storyModel)
            
            // Update the completion status for the next iteration
            isPreviousStoryComplete = storyModel.isComplete
        }
        
        return storyModels
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
