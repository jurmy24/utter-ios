//
//  StoryCompleteView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-20.
//

import SwiftUI

struct StoryCompleteView: View {
    let storyMetadata: Story
    @Binding var showStoryView: Bool
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            Text("Congratulations!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("AccentColor"))
                .padding()
            
            VStack(spacing:8) {
                Text("You’ve completed chapter \(storyMetadata.currentChapter) of")
                    .font(.title2)
                    .foregroundColor(Color("TextColor"))
                
                Text(storyMetadata.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextColor"))
                    .padding(.bottom, 20)
            }

            // Image placeholder for the story
            if let image = self.image {
                StoryImageCard(image: image, widthPercentage: 0.8, heightPercentage: 0.5)
                    .padding(.bottom, 20)
            } else {
                // Placeholder while image loads
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(
                        width: UIScreen.main.bounds.width * 0.8,
                        height: UIScreen.main.bounds.height * 0.5
                    )
                    .cornerRadius(10)
                    .overlay(
                        ProgressView() // Optional: Add a loading indicator
                    )
                    .padding(.bottom, 20)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .task {
            guard let imageLocation = storyMetadata.imageLocation else {
                showStoryView = false
                return
            }
            let image = try? await StorageManager.shared.getImage(path: imageLocation)
            self.image = image
        }
        .background(Color("AppBackgroundColor"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    StoryCompleteView(storyMetadata: Story.sample1, showStoryView: .constant(true))
}

