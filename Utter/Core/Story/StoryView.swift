//
//  StoryView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

final class StoryViewModel: ObservableObject {
    //    @Published var blocks:
}

struct StoryView: View {
    
    @StateObject private var viewModel = StoryViewModel()
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 20){
                let blocks = [1, 2, 3]
                ForEach(blocks, id: \.self) { block in
                    TextBlob(avatar: "person.circle.fill", text: "Tjenare mannen, det går bra för min del. Hur går det för dig? Hur går det för dig? Hur går det för dig?", modifier: .hideAudio)
                        .padding(.horizontal, 16)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    StoryView()
}
