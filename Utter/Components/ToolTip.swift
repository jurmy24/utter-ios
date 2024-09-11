//
//  ToolTip.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

struct ToolTip<Content: View>: View {
    let alignment: Edge
    @Binding var isVisible: Bool
    let backgroundColor: Color
    let content: () -> Content
    let arrowOffset = CGFloat(8)
    
    
    private var oppositeAlignment: Alignment {
        let result: Alignment
        switch alignment {
        case .top: result = .bottom
        case .bottom: result = .top
        case .leading: result = .trailing
        case .trailing: result = .leading
        }
        return result
    }
    
    private var theTip: some View {
        content()
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(20)
            .background(alignment: oppositeAlignment) {
                
                // The arrow is a square that is rotated by 45 degrees
                Rectangle()
                    .fill(backgroundColor)
                    .frame(width: 22, height: 22)
                    .rotationEffect(.degrees(45))
                    .offset(x: alignment == .leading ? arrowOffset : 0)
                    .offset(x: alignment == .trailing ? -arrowOffset : 0)
                    .offset(y: alignment == .top ? arrowOffset : 0)
                    .offset(y: alignment == .bottom ? -arrowOffset : 0)
            }
            .padding()
            .fixedSize()
    }
    
    var body: some View {
        if isVisible {
            GeometryReader { proxy1 in
                // Use a hidden version of the hint to form the footprint
                theTip
                    .hidden()
                    .overlay {
                        GeometryReader { proxy2 in
                            
                            // The visible version of the hint
                            theTip
                                .drawingGroup()
                                .shadow(radius: 4)
                            
                            // Center the hint over the source view
                                .offset(
                                    x: -(proxy2.size.width / 2) + (proxy1.size.width / 2),
                                    y: -(proxy2.size.height / 2) + (proxy1.size.height / 2)
                                )
                            // Move the hint to the required edge
                                .offset(x: alignment == .leading ? (-proxy2.size.width / 2) - (proxy1.size.width / 2) : 0)
                                .offset(x: alignment == .trailing ? (proxy2.size.width / 2) + (proxy1.size.width / 2) : 0)
                                .offset(y: alignment == .top ? (-proxy2.size.height / 2) - (proxy1.size.height / 2) : 0)
                                .offset(y: alignment == .bottom ? (proxy2.size.height / 2) + (proxy1.size.height / 2) : 0)
                        }
                    }
            }
            .onTapGesture {
                isVisible.toggle()
            }
        }
    }
}
