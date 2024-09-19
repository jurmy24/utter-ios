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
                    
                    TextBlob(avatar: "person.circle.fill", character: line.character.rawValue, text: line.text, modifier: action)
//                    switch action {
//                    case .hideText, .hideAll:
//                        Text("[Text Hidden]")
//                            .italic()
//                            .foregroundColor(.gray)
//                    case .emphasizeText:
//                        Text(line.character.rawValue + ": " + line.text)
//                            .bold()
//                            .foregroundColor(.blue)
//                    case .hideAudio, .none:
//                        Text(line.character.rawValue + ": " + line.text)
//                    }
                }
            }
        }
    }
}

//#Preview {
//    StoryBlockView()
//}
