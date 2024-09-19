//
//  StoryImageCard.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct StoryImageCard: View {
    let image: UIImage
    let widthPercentage: CGFloat
    let heightPercentage: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(
                width: UIScreen.main.bounds.width * widthPercentage, // Set width as a percentage of screen width
                height: UIScreen.main.bounds.height * heightPercentage // Set height as a percentage of screen height
            )
            .clipped() // Ensures the image doesn't overflow the frame
            .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5) // Adding shadow
            .cornerRadius(10) // Optional: To give it rounded corners
    }
}

#Preview {
    StoryImageCard(image: UIImage(systemName: "photo")!, widthPercentage: 0.8, heightPercentage: 0.7)
}

