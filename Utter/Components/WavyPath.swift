//
//  WavyPath.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

struct WavyPathView: View {
    let circleRelativeCenters = [
        CGPoint(x: 0.5, y: 0.9),
        CGPoint(x: 0.3, y: 0.7),
        CGPoint(x: 0.7, y: 0.5),
        CGPoint(x: 0.2, y: 0.3),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            // 1. Normalize the centers relative to the geometry size
            
            let normalizedCenters = circleRelativeCenters.map { center in
                CGPoint(
                    x: center.x * geometry.size.width,
                    y: center.y * geometry.size.height
                )
            }
            
            // 2. Draw the wavy path between points
            let wavyPath = Path { path in
                var prevPoint = CGPoint(x: normalizedCenters[0].x, y: normalizedCenters[0].y)
                path.move(to: prevPoint)
                for center in normalizedCenters.dropFirst() {
                    let controlPoint = CGPoint(
                        x: (center.x + prevPoint.x) / 3,
                        y: (center.y + prevPoint.y) / 2
                    )
                    path.addQuadCurve(to: center, control: controlPoint) //addQuadCurve , control: controlPoint
                    prevPoint = center
                }
            }

            // 3. Display the wavy path
            wavyPath
                .stroke(lineWidth: 20)
                .foregroundColor(.accentColor)
            
            // 4. Create path for circles with rounded corners
            let circlePath = Path { path in
                let circleDiameter = geometry.size.width / 5
                let circleFrameSize = CGSize(width: circleDiameter, height: circleDiameter)
                let circleCornerSize = CGSize(width: circleDiameter / 2, height: circleDiameter / 2)
                for center in normalizedCenters {
                    let rect = CGRect(
                        origin: CGPoint(
                            x: center.x - circleFrameSize.width / 2,
                            y: center.y - circleFrameSize.width / 2
                        ),
                        size: circleFrameSize
                    )
                    path.addRoundedRect(in: rect, cornerSize: circleCornerSize)
                }
            }

            
            // 5. Draw StoryBlobs at each point
            ForEach(normalizedCenters.indices, id: \.self) { i in
                let center = normalizedCenters[i]
                let circleDiameter = geometry.size.width / 4
                let circleFrameSize = CGSize(width: circleDiameter, height: circleDiameter)
                StoryBlob(level: 1, isLocked: false, storyTitle: "Zlatan", numberOfChapters: 3, completedChapters: 2, size: circleDiameter)
                    .offset(
                        x: center.x - circleFrameSize.width / 2,
                        y: center.y - circleFrameSize.height / 2
                    )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackgroundColor"))
    }

}

#Preview {
    //    let circleRelativeCenters = [
    //        CGPoint(x: 0.8, y: 0.2),
    //        CGPoint(x: 0.2, y: 0.5),
    //        CGPoint(x: 0.8, y: 0.8),
    //    ]
    
    WavyPathView()
}

