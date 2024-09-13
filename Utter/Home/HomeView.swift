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
    let verticalSpacingMultiplier: CGFloat = 0.9
    
    // Fixed scrollable content height (you can adjust this based on your layout)
    let contentHeight: CGFloat = 2000
    let screenWidth = UIScreen.main.bounds.width
    
    // Generate random horizontal positions and equally spaced vertical positions (relative)
    func generateBlobPositions() -> [CGPoint] {
        let margin = blobSize / 1.8 / screenWidth // Ensure the blob stays within bounds as a percentage of screen width
        let positions = (0..<numberOfBlobs).map { index in
            let normalizedX = (sin(CGFloat(index)) + 1) / 2 // Generates values between 0 and 1 based on index
            let constrainedX = margin + normalizedX * (1 - 2 * margin) // Constrain x to be within [margin, 1 - margin]
            
            return CGPoint(
                x: constrainedX, // Pseudo-random horizontal position based on index
                y: CGFloat(0.95) - (CGFloat(index) * (blobSize + blobSize * verticalSpacingMultiplier) / contentHeight) // Inversely spaced vertically, normalized
            )
        }
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


