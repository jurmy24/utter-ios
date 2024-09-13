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
