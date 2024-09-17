//
//  WordWrapView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 4

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard var maxWidth = proposal.width else {
            return CGSize.zero
        }

        if maxWidth.isInfinite {
            maxWidth = UIScreen.main.bounds.width - 40 // Adjust as needed
        }

        var totalSize = CGSize.zero
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            if lineWidth + subviewSize.width + spacing > maxWidth {
                totalSize.width = max(totalSize.width, lineWidth)
                totalSize.height += lineHeight + spacing
                lineWidth = subviewSize.width
                lineHeight = subviewSize.height
            } else {
                lineWidth += subviewSize.width + spacing
                lineHeight = max(lineHeight, subviewSize.height)
            }
        }

        totalSize.width = max(totalSize.width, lineWidth)
        totalSize.height += lineHeight

        return totalSize
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        var lineHeight: CGFloat = 0
        let maxWidth = bounds.width

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            if origin.x + subviewSize.width > maxWidth {
                origin.x = bounds.origin.x
                origin.y += lineHeight + spacing
                lineHeight = 0
            }

            subview.place(
                at: CGPoint(x: origin.x, y: origin.y),
                proposal: ProposedViewSize(width: subviewSize.width, height: subviewSize.height)
            )

            origin.x += subviewSize.width + spacing
            lineHeight = max(lineHeight, subviewSize.height)
        }
    }
}


struct WordWrapView: View {
    let words: [String]
    let action: (String) -> Void
    
    var body: some View {
        FlowLayout(spacing: 4) {
            ForEach(words, id: \.self) { word in
                WordView(word: word, action: action)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}



#Preview {

    // Speech bubble containing the text
    HStack {
        
        if true {
            Button {
                // Replay the Audio file
            } label: {
                Image(systemName: "speaker.wave.2.fill")
                    .foregroundColor(Color("AccentColor"))
            }
        }
        
        let text = "What the heck is going on god damn it"
        if true {
            
            let words = text.components(separatedBy: " ")
            WordWrapView(words: words) { word in
                // Handle tap on word
                print("Tapped on word: \(word)")
            }
            .background(Color.red.opacity(0.2))
        } else {
            Text(text)
                .font(.headline)
                .foregroundColor(Color("TextColor"))
        }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 8)
    .background(Color.white) // Replace with your desired background
    .clipShape(SpeechBubble()) // Apply speech bubble shape
    .overlay(
        SpeechBubble()
            .stroke(Color("AccentColor"), lineWidth: 3)
    )
    .padding()
    
}
