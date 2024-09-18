//
//  StoryView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct StoryView: View {
    
    let story: Story
    @StateObject private var viewModel = StoryViewModel()
    @State private var textInfo: String = ""
    
    var body: some View {
        ScrollView {
//            VStack (alignment: .leading, spacing: 30){
//                let blocks = [1, 2, 3]
//                ForEach(blocks, id: \.self) { block in
//                    TextBlob(avatar: "person.circle.fill", text: "Tjenare mannen, det går bra för min del. Hur går det för dig? Hur går det för dig? Hur går det för dig?", modifier: .hideAudio)
//                        .padding(.horizontal, 16)
//                }
//                
//                Spacer()
//            }
            // TODO: print the json file in the Text() here
            Text(textInfo)
            
//            if let jsonData, let jsonData = JSONSerialization(jsonData) {
//                Text
//            }
        }
        .task {
            guard let storageLocation = story.story.storageLocation else {
                textInfo = "storageLocation not found"
                return
            }
            do {
                try await viewModel.loadStory(path: storageLocation)
                textInfo = viewModel.storyString
            } catch {
                textInfo = "unable to load story"
            }
        }
    }
}

//#Preview {
//    StoryView()
//}
