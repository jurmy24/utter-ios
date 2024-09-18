//
//  LabelledDivider.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-09.
//

import SwiftUI

struct LabelledDivider: View {

    let label: String
    let horizontalPadding: CGFloat
    let color: Color

    init(label: String, horizontalPadding: CGFloat = 20, color: Color = .gray) {
        self.label = label
        self.horizontalPadding = horizontalPadding
        self.color = color
    }

    var body: some View {
        HStack {
            line
            Text(label)
                .foregroundColor(color)
                .font(.caption)
            line
        }
    }

    var line: some View {
        VStack { Divider().background(color) }.padding(horizontalPadding)
    }
}

#Preview {
    LabelledDivider(label: "Or continue with")
}
