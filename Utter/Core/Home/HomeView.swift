//
//  HomeView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct HomeView: View {
    
    // TODO: The selected language should be what is chosen in the Language view
    @StateObject private var viewModel = HomeViewModel(selectedLanguage: .swedish)
    
    var body: some View {
        if viewModel.storiesWithProgress.isEmpty {
            VStack {
                Spacer()
                ProgressView("Loading stories...")
                    .progressViewStyle(CircularProgressViewStyle())
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("AppBackgroundColor"))
            .edgesIgnoringSafeArea(.all)
        } else {
            ScrollView(.vertical) {
                ZStack {
                    let circleRelativeCenters = viewModel.generateBlobPositions()
                    
                    // 1. Wavy Path connecting the story blobs
                    WavyPath(circleRelativeCenters: circleRelativeCenters, color: Color("ButtonColor").opacity(0.5), thickness: 30)
                        .frame(width: UIScreen.main.bounds.width, height: viewModel.contentHeight)
                    
                    // 2. Position StoryBlobs along the wavy path
                    ForEach(viewModel.storiesWithProgress) { storyWithProgress in
                        let index = storyWithProgress.story.level - 1
                        if index >= 0 && index < circleRelativeCenters.count {
                            let position = circleRelativeCenters[index]
                            
                            StoryBlob(
                                level: storyWithProgress.story.level,
                                isLocked: storyWithProgress.isLocked,
                                storyTitle: storyWithProgress.story.title,
                                storyDescription: storyWithProgress.story.description,
                                numberOfChapters: storyWithProgress.story.chapters,
                                completedChapters: storyWithProgress.currentChapter,
                                size: viewModel.blobSize
                            )
                            .position(
                                x: position.x * UIScreen.main.bounds.width,
                                y: position.y * viewModel.contentHeight
                            )
                        }
                        
                        /* If I want to paginate */
//                        if story == viewModel.stories.last {
//                            ProgressView()
//                                .onAppear {
//                                    print("Progress View Appeared")
//                                    Task {
//                                        try await viewModel.getStoriesForLanguageLimited(language: .swedish)
//                                    }
//                                    
//                                }
//                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width, height: viewModel.contentHeight)
            }
            .padding(.bottom, 100)
            .defaultScrollAnchor(.bottom)
            .scrollIndicators(.hidden)
            .background(Color("AppBackgroundColor"))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    HomeView()
}
