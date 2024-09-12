//
//  HomeView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    // Number of StoryBlobs
    let numberOfBlobs = 5
    
    // Define the size of the StoryBlob and the vertical spacing multiplier
    let blobSize: CGFloat = 100
    // Set a multiplier for vertical spacing
    let verticalSpacingMultiplier: CGFloat = 1.5
    
    // Fixed scrollable content height (you can adjust this based on your layout)
    let contentHeight: CGFloat = 2000
    let screenWidth = UIScreen.main.bounds.width
    
    // Generate random horizontal positions and equally spaced vertical positions (relative)
    func generateBlobPositions() -> [CGPoint] {
        let margin = blobSize / 1.8 / screenWidth // Ensure the blob stays within bounds as a percentage of screen width
        let positions = (0..<numberOfBlobs).map { index in
            CGPoint(
                x: CGFloat.random(in: margin...(1 - margin)), // Random horizontal position, normalized
                y:CGFloat(0.95) - (CGFloat(index) * (blobSize + blobSize * verticalSpacingMultiplier) / contentHeight) // Inversely spaced vertically, normalized
            )
        }
        print(positions)
        return positions
    }

    
}

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    
    var body: some View {
        // Define relative positions for the StoryBlobs along the wavy path
        
        
        
        ScrollView(.vertical, content: {
            ZStack {
                let circleRelativeCenters: [CGPoint] = viewModel.generateBlobPositions()
                
                // 1. Wavy Path connecting the story blobs
                WavyPath(circleRelativeCenters: circleRelativeCenters, color: .accentColor, thickness: 30)
                    .frame(width: UIScreen.main.bounds.width, height: viewModel.contentHeight)
                
                // 2. Position StoryBlobs along the wavy path
                ForEach(0..<circleRelativeCenters.count, id: \.self) { index in
                    let position = circleRelativeCenters[index]
                    
                    StoryBlob(
                        level: index + 1,
                        isLocked: index > 2, // Lock levels after the first two
                        storyTitle: "Level \(index + 1)",
                        storyDescription: "Description for Level \(index + 1)",
                        numberOfChapters: 4,
                        completedChapters: index % 4, // Simulate progress
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


