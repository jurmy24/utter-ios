//
//  CircularProgressBarBackgroundView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct CircularProgressBarBackgroundView: View {
    let total: Int
    @State var lineWidth: CGFloat = 16
    var shortDashSize: CGFloat { 10 }
    func longDashSize(circleWidth: CGFloat) -> CGFloat {
        .pi * circleWidth / CGFloat(total) - shortDashSize
    }
    
    var body: some View {
        GeometryReader { geometry in
            Circle()
                .stroke(Color(white: 230/255),
                        style: StrokeStyle(
                            lineWidth: lineWidth / 1.6,
                            lineCap: .butt,
                            lineJoin: .miter,
                            miterLimit: 0,
                            dash: [
                                longDashSize(circleWidth: geometry.size.width),
                                shortDashSize
                            ],
                            dashPhase: 0))
                .rotationEffect(.degrees(-90))
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2) // Center the circle
        }
        .padding(lineWidth/2)
    }
}

#Preview {
    CircularProgressBarBackgroundView(total: 3, lineWidth: 30)
}
