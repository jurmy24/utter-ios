//
//  TextBlob.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-16.
//

import SwiftUI

struct SpeechBubble: Shape {
    private let radius: CGFloat
    private let tailSize: CGFloat
    
    init(radius: CGFloat = 10) {
        self.radius = radius
        tailSize = 20
    }
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2))
            path.addCurve(
                to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2 - tailSize),
                control1: CGPoint(x: rect.minX - tailSize, y: rect.maxY - rect.height / 2),
                control2: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2 - tailSize / 2)
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 180),
                endAngle: Angle(degrees: 270),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                radius: radius,
                startAngle: Angle(degrees: 270),
                endAngle: Angle(degrees: 0),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 0),
                endAngle: Angle(degrees: 90),
                clockwise: false
            )
            path.addArc(
                center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                radius: radius,
                startAngle: Angle(degrees: 90),
                endAngle: Angle(degrees: 180),
                clockwise: false
            )
        }
    }
}

struct TextBlob: View {
    var avatar: String // This can be the name of an SF Symbol or Image
    var text: String
    var showAudioIcon: Bool = true // Optional audio icon toggle
    var underlineText: Bool = true
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Avatar on the left
            Image(systemName: avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            
            // Speech bubble containing the text
            ZStack {
                SpeechBubble()
                    .stroke(Color("AccentColor"), lineWidth: 3)
                HStack(spacing: 10) {
                    
                    if showAudioIcon {
                        Button {
                            // Replay the Audio file
                        } label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundColor(Color("AccentColor"))
                                .padding(.leading)
                        }
                    }
                    
                    if underlineText {
                        let words = text.components(separatedBy: " ")
                        WordWrapView(words: words) { word in
                            // Handle tap on word
                            print("Tapped on word: \(word)")
                        }
                    } else {
                        Text(text)
                            .font(.headline)
                            .foregroundColor(Color("TextColor"))
                            .frame(maxWidth: .infinity)
                            .padding(.trailing)
                    }
                    
                    
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    TextBlob(avatar: "person.circle.fill", text: "Tjenare mannen, det går bra för min del. Hur går det för dig?")
}

