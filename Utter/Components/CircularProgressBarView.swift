//
//  CircularProgressBarView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-10.
//

import SwiftUI

struct CircularProgressBarView: View {
    let total: Int
    let completed: Int
    let color: Color
    let lineWidth: CGFloat
    
    var body: some View {
        ZStack {
            CircularProgressBarBackgroundView(total: total, lineWidth: lineWidth)
            CircularProgressBarProgressView(total: total, completed: completed, lineWidth: lineWidth, color: color)
        }
    }
}

#Preview {
    CircularProgressBarView(total: 3, completed: 1, color: .accentColor, lineWidth: 30)
}
