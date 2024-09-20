//
//  StoryBlockView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-19.
//

import SwiftUI

struct StoryBlockView: View {
    let block: Block
    let currentLineIndex: Int
    let modifications: [String: Action]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<(block.lines?.count ?? 0), id: \.self) { index in
                if index <= currentLineIndex, let line = block.lines?[index] {
                    let key = "\(block.id)-\(line.id)"
                    let action = modifications[key]
                    
                    TextBlob(avatar: "person.circle.fill", character: line.character, text: line.text, modifier: action)
                        .onAppear {
                            print("This is the modification for the line \(line.text)")
                            print(action?.rawValue ?? "No modification")
                        }
                }
            }
        }
    }
}

//#Preview {
//    StoryBlockView()
//}
