//
//  ToolTip.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2024-09-11.
//

import SwiftUI

class TooltipViewModel: ObservableObject {
    
    func computeHorizontalOffset(screenWidth: CGFloat, tooltipWidth: CGFloat, parentWidth: CGFloat, tooltipX: CGFloat) -> CGFloat {
        // Calculate the center offset
        var centerOffsetX = -(tooltipWidth / 2) + (parentWidth / 2)
        
        let leftMost = tooltipX + centerOffsetX
        let rightMost = tooltipX + centerOffsetX + tooltipWidth
        
        if leftMost < 0 {
            centerOffsetX = centerOffsetX - leftMost
        }
        
        if rightMost > screenWidth {
            centerOffsetX = centerOffsetX - (rightMost - screenWidth)
        }
        
        // Otherwise, keep it centered
        return centerOffsetX
    }
    
    func computeArrowHorizontalOffset(screenWidth: CGFloat, tooltipWidth: CGFloat, parentWidth: CGFloat, tooltipX: CGFloat, horizontalOffset: CGFloat) -> CGFloat {
        // Calculate the original center offset when the tooltip is perfectly centered over the parent
        let originalCenterOffsetX = -(tooltipWidth / 2) + (parentWidth / 2)
        
        // Initialize the arrow offset with the horizontal offset
        var arrowOffset = 0.0
        
        // Calculate the leftmost and rightmost positions of the tooltip
        let leftMost = tooltipX + originalCenterOffsetX
        let rightMost = tooltipX + originalCenterOffsetX + tooltipWidth
        
        // Adjust the arrow offset if the tooltip goes off the left edge of the screen
        if leftMost < 0 {
            arrowOffset += leftMost / 2
        }
        
        // Adjust the arrow offset if the tooltip goes off the right edge of the screen
        if rightMost > screenWidth {
            arrowOffset += (rightMost - screenWidth) / 2
        }
    
        return arrowOffset
    }
}

struct ToolTip<Content: View>: View {
    let alignment: Edge
    @Binding var isVisible: Bool
    let backgroundColor: Color
    let content: () -> Content
    let arrowOffset = CGFloat(8)
    
    @StateObject private var viewModel = TooltipViewModel() // Initialize view model
    
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
    }
    
    var body: some View {
        if isVisible {
            GeometryReader { proxy1 in
                // Use a hidden version of the hint to form the footprint
                theTip
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
                    .hidden()
                    
                    .overlay {
                        GeometryReader { proxy2 in
                            
                            // Get the screen width and tooltip width
                            let screenWidth = UIScreen.main.bounds.width
                            let tooltipWidth = proxy2.size.width
                            let parentWidth = proxy1.size.width
                            let tooltipFrame = proxy2.frame(in: .global)
                            let tooltipX = tooltipFrame.origin.x
                            
                            // Calculate horizontal offset and arrow adjustments using ViewModel
                            let adjustedOffsetX = viewModel.computeHorizontalOffset(screenWidth: screenWidth, tooltipWidth: tooltipWidth, parentWidth: parentWidth, tooltipX: tooltipX)
                            let arrowCenterOffset = viewModel.computeArrowHorizontalOffset(screenWidth: screenWidth, tooltipWidth: tooltipWidth, parentWidth: parentWidth, tooltipX: tooltipX, horizontalOffset: adjustedOffsetX)
                            
                            // The visible version of the hint
                            theTip
                                .background(alignment: oppositeAlignment) {
                                    // The arrow is a square that is rotated by 45 degrees
                                    Rectangle()
                                        .fill(backgroundColor)
                                        .frame(width: 22, height: 22)
                                        .rotationEffect(.degrees(45))
                                        .offset(x: alignment == .leading ? arrowOffset : arrowCenterOffset)
                                        .offset(x: alignment == .trailing ? -arrowOffset : arrowCenterOffset)
                                        .offset(y: alignment == .top ? arrowOffset : 0)
                                        .offset(y: alignment == .bottom ? -arrowOffset : 0)
                                }
                                .padding()
                                .fixedSize()
                                .drawingGroup()
                                .shadow(radius: 4)

                            // Center the hint over the source view
                                .offset(
                                    x: adjustedOffsetX,
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
        }
    }
}
