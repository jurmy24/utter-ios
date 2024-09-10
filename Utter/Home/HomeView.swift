//
//  HomeView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            StoryBlob(storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3)
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    HomeView()
}
