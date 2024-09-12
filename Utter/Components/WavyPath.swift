//
//  WavyPath.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

struct WavyPath: View {
    let circleRelativeCenters: [CGPoint]
    let color: Color
    let thickness: CGFloat
    
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
                .stroke(lineWidth: thickness)
                .foregroundColor(color)
            
            // 4. Create path for circles with rounded corners
            let _ = Path { path in
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
        }
    }
    
}

#Preview {
    WavyPath(circleRelativeCenters: [
        CGPoint(x: 0.5, y: 0.9),
        CGPoint(x: 0.3, y: 0.7),
    ], color: .blue, thickness: 30)
}
