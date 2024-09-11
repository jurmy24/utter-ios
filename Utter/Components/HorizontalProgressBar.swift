//
//  HorizontalProgressBar.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

struct HorizontalProgressBar: View {
    let chapters: Int
    let chaptersRead: Int
    let lineThickness: CGFloat
    let color: Color
    let cornerRadius: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 4) {
                ForEach(0..<chapters, id: \.self) { index in
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(index < chaptersRead ? color : Color.gray.opacity(0.3))
                        .frame(width: (geometry.size.width / CGFloat(chapters)) - 4, height: lineThickness)
                }
            }
        }
    }
}

#Preview {
    HorizontalProgressBar(chapters: 3, chaptersRead: 2, lineThickness: 10, color: .accentColor)
}

