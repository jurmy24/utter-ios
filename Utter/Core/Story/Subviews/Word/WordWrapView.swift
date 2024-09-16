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
        var totalSize = CGSize.zero
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        let maxWidth = proposal.replacingUnspecifiedDimensions().width ?? .infinity

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
    }
}



#Preview {
    WordWrapView(words: ["this", "is", "a", "test"]) { word in
                // Handle tap on word
                print("Tapped on word: \(word)")
            }
            .padding()
}
