//
//  TestStoryLoadView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-15.
//

import SwiftUI

@MainActor
final class TestStoryLoadViewModel: ObservableObject {
    
    
    
    
//    func downloadStoriesAndUploadToFirebase() {
//        
//        let storyArray = StoryDatabase.stories
//        
//        Task {
//            do {
//                for story in storyArray {
//                    try? await StoryManager.shared.uploadStory(story: story)
//                }
//                print("SUCCESS")
//            } catch {
//                print(error)
//            }
//        }
//        
//    }
}

struct TestStoryLoadView: View {
    
    @StateObject private var viewModel = HomeViewModel(selectedLanguage: .swedish)
//    @StateObject private var dbModel = TestStoryLoadViewModel()
    
    var body: some View {
        Text("Language: \(viewModel.selectedLanguage?.rawValue ?? "None")")
        List {
            ForEach(viewModel.stories) { story in
                Text(story.title + ", level: " + (String(story.level)))
            }
        }
        .navigationTitle("Stories")
//        .task {
////            try? await viewModel.getAllStories()
//            do {
//                try await viewModel.getStoriesForLanguage(language: .swedish)
//            } catch {
//                print(error)
//            }
//        }
//        Text("Blablabal")
//            .onAppear {
//                dbModel.downloadStoriesAndUploadToFirebase()
//            }
        
    }
    
}

#Preview {
    NavigationStack {
        TestStoryLoadView()
    }
}
