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
            StoryBlob(level: 1, isLocked: true, storyTitle: "Zlatan", numberOfChapters: 4, completedChapters: 3, size: 100)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }
}

#Preview {
    HomeView()
}
