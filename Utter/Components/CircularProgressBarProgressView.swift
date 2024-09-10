//
//  CircularProgressBarProgressView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct CircularProgressBarProgressView: View {
    let total: Int
    let completed: Int
    @State var lineWidth: CGFloat = 16
    @State var color: Color = .green
    var body: some View {
        Circle()
            .trim(from: 0, to: CGFloat(completed)/CGFloat(total))
            .stroke(color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    ))
            .rotationEffect(.degrees(-90))
            .padding(lineWidth/2)
    }
}

#Preview {
    Group {
        CircularProgressBarProgressView(total: 3, completed: 1)
        CircularProgressBarProgressView(total: 3, completed: 2)
        CircularProgressBarProgressView(total: 3, completed: 3)
    }
}
