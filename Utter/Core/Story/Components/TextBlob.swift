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
    var avatar: String
    var character: String
    var text: String
    var modifier: Action?
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            // Avatar on the left
            if character != "Narrator" {
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
            
            // Speech bubble containing the text
            HStack {
                
                switch modifier {
                case .hideAll:
                    Button {} label: {
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 20)) // Set the desired size
                    }
                    .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
                    
                    Text(text)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .blur(radius: 4)
                case .hideAudio:
                    Button {} label: {
                        Image(systemName: "speaker.slash.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 20)) // Set the desired size
                    }
                    .allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
                    
                    Text(text)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .fontWeight(.bold)
                case .hideText:
                    Button {
                        // Replay the Audio file
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 20)) // Set the desired size
                    }
                    
                    Text(text)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .blur(radius: 4)
                case .emphasizeText:
                    Button {
                        // Replay the Audio file
                    } label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 20)) // Set the desired size
                    }
                    
                    Text(text)
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(Color("TextColor"))
                case nil:
                    Button {
                        // Replay the Audio file
                    } label: {
                        // Place the Image at the top
                        Image(systemName: "speaker.wave.2.fill")
                            .foregroundColor(Color("AccentColor"))
                            .font(.system(size: 20))
                    }
                    
                    Text(text)
                        .font(.headline)
                        .foregroundColor(Color("TextColor"))
                        .fontWeight(.bold)
                }
                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(SpeechBubble())
            .overlay(
                character != "Narrator" ?
                SpeechBubble()
                    .stroke(modifier == nil ? Color("ReverseAccent") : Color("AccentColor"), lineWidth: 3)
                : nil
            )
        }
    }
}


#Preview {
    TextBlob(avatar: "person.circle.fill", character: "Narrator", text: "Tjenare mannen, det går bra för min del. Hur går det för dig? Hur går det för dig? Hur går det för dig?")
}

