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
        self.tailSize = 15
    }
    
    func path(in rect: CGRect) -> Path {
    
        Path { path in
            
            var tailParam = 2
            if rect.height < 60 {
                tailParam = 3
            }
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY - radius))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / 2))
            path.addCurve(
                to: CGPoint(x: rect.minX, y: rect.maxY - rect.height / CGFloat(tailParam) - tailSize),
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
    var avatar: String
    var character: String
    var text: String
    var audioPath: String
    var modifier: Action?
    @State private var hasPlayedAudio = false

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Avatar on the left
            if character != "Narrator" {
                avatarView
                    .padding(.top, 5)
            }

            // Speech bubble containing the text and button
            HStack (alignment: .top, spacing: 3){
                speakerButton
                textView
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 10)
            .frame(alignment: .leading)
            .clipShape(SpeechBubble())
            .overlay(
                character != "Narrator" ?
                SpeechBubble().stroke(bubbleStrokeColor, lineWidth: 2) : nil
            )
        }
        .onAppear {
            // This plays every time it appears on the screen
            // Only play the audio if it hasn't been played before
            if !self.hasPlayedAudio {
                    Task {
                        if self.modifier != .hideAudio, self.modifier != .hideAll {
                            let data = try await StorageManager.shared.getData(path: self.audioPath)
                            AudioManager.shared.playAudio(data: data)
                            
                            // Mark audio as played
                            self.hasPlayedAudio = true
                        }
                    }
                }
        }
    }

    // Avatar view
    @ViewBuilder
    var avatarView: some View {
        VStack {
            Image(systemName: avatar)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            Text(character)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(Color("TextColor"))
        }
    }

    // Button to replay audio
    var speakerButton: some View {
        Button(action: {
            // Replay the audio file
            Task {
                if self.modifier != .hideAudio, self.modifier != .hideAll {
                    let data = try await StorageManager.shared.getData(path:self.audioPath)
                    AudioManager.shared.playAudio(data: data)
                }
            }
            
        }) {
            Image(systemName: modifier == .hideAudio || modifier == .hideAll ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .foregroundColor(Color("AccentColor"))
                .font(.system(size: 18))
                .padding(.leading, 4)
                .padding(.top, 3)
        }
        .allowsHitTesting(!(modifier == .hideAll || modifier == .hideAudio))
    }

    // Display the text with optional modifications
    var textView: some View {
        if modifier != .hideAll {
            Text(text)
                .font(.body)
                .fontWeight(modifier == .emphasizeText ? .bold : .regular)
                .blur(radius: modifier == .hideText ? 4 : 0)
                .foregroundColor(modifier != .emphasizeText ? Color("TextColor") : Color("AccentColor"))
        } else {
            Text(text)
                .font(.body)
                .blur(radius: 0)
                .foregroundColor(Color("AppBackgroundColor"))
        }
        
    }

    // Bubble stroke color based on modifier
    var bubbleStrokeColor: Color {
        modifier == nil ? Color("ReverseAccent") : Color("AccentColor")
    }
}

#Preview {
    TextBlob(avatar: "person.circle.fill", character: "Chris", text: "Tjenare mannen", audioPath: "potato", modifier: .emphasizeText)
}

//, det går bra för min del. Hur går det för dig?
