//
//  StoryTitleView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct StoryTitleView: View {
    let storyMetadata: Story
    @Binding var showStoryView: Bool
    @State private var isVisible = false
    @State private var image: UIImage? = nil
    
    var body: some View {
        VStack {
            Text(storyMetadata.title)
                .font(.title)
                .fontWeight(.black)
                .foregroundColor(Color("AccentColor"))
                .opacity(isVisible ? 1.0 : 0.0) // Fade in from opacity 0 to 1
                .animation(.easeIn(duration: 1.0), value: isVisible) // Adjust the duration as needed
                .onAppear {
                    isVisible = true
                }
                .padding()
            
            // Add a fixed-size image placeholder
            ZStack {
                if let image = self.image {
                    StoryImageCard(image: image, widthPercentage: 0.8, heightPercentage: 0.6)
                } else {
                    // Placeholder while image loads
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(
                            width: UIScreen.main.bounds.width * 0.8,
                            height: UIScreen.main.bounds.height * 0.6
                        )
                        .cornerRadius(10)
                        .overlay(
                            ProgressView() // Optional: Add a loading indicator
                        )
                }
            }
            .padding(.bottom, 20)
            
            StoryButton(text: "Start!", color: Color("AccentColor"), action: {
                // Navigate to the first chapter view, but a fullscreencover might be unneccessary
            })
            .padding()
        }
        .task {
            guard let imageLocation = storyMetadata.imageLocation else {
                showStoryView = false
                return
            }
            let image = try? await StorageManager.shared.getImage(path: imageLocation)
            self.image = image
        }
    }
}

#Preview {
    StoryTitleView(storyMetadata: Story.sample1 ,showStoryView: .constant(true))
}
