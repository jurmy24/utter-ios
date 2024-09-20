//
//  ChapterTitleView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct ChapterTitleView: View {
    let chapterTitle: String
    let chapterNumber: Int
    
    @State private var isVisible = false
    
    var body: some View {
        Text("\(String(chapterNumber)).\t" + chapterTitle)
            .font(.title2)
            .fontWeight(.black)
            .foregroundColor(Color("TextColor"))
            .offset(x: isVisible ? 0 : -UIScreen.main.bounds.width) // Start off-screen, slide in
            .animation(.easeOut(duration: 1.0), value: isVisible) // Slide in with easeOut
            .onAppear {
                isVisible = true
            }
            .padding()
    }
}

#Preview {
    ChapterTitleView(chapterTitle: "En dejt mellan Anna och Karl", chapterNumber: 1)
}
