//
//  HomeView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI


struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        // Define relative positions for the StoryBlobs along the wavy path
        
        ScrollView(.vertical, content: {
            ZStack {
                let circleRelativeCenters: [CGPoint] = viewModel.generateBlobPositions()
                
                // 1. Wavy Path connecting the story blobs
                WavyPath(circleRelativeCenters: circleRelativeCenters, color: Color("ButtonColor").opacity(0.5), thickness: 30)
                    .frame(width: UIScreen.main.bounds.width, height: viewModel.contentHeight)
                
                // 2. Position StoryBlobs along the wavy path
                ForEach(0..<circleRelativeCenters.count, id: \.self) { index in
                    let position = circleRelativeCenters[index]
                    
                    StoryBlob(
                        level: index + 1,
                        isLocked: index > 1, // Lock levels after the second level
                        storyTitle: "Random title",
                        storyDescription: "Description for Level \(index + 1)",
                        numberOfChapters: 4,
                        completedChapters: {
                            switch index {
                            case 0: return 4 // First level is complete
                            case 1: return 3 // Second level is almost complete
                            default: return 0 // Remaining levels are locked
                            }
                        }(),
                        size: 100
                    )
                    .position(
                        x: position.x * UIScreen.main.bounds.width, // Width is screen-based
                        y: position.y * viewModel.contentHeight // Height is based on scrollable area
                    )
                }
            }
            .frame(width: UIScreen.main.bounds.width, height: viewModel.contentHeight) // Set the scrollable content size
            
        })
        .defaultScrollAnchor(.bottom) // Set the default scroll anchor to the bottom
        .scrollIndicators(.hidden)
        .background(Color("AppBackgroundColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    HomeView()
}


