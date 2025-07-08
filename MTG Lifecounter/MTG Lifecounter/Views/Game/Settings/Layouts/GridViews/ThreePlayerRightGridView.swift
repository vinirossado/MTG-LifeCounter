//
//  ThreePlayerRightGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for three-player layout selection.
/// Shows the arrangement where two players are stacked on the left and one player takes the right side.
/// Follows MTG theming with mystical backgrounds and proper accessibility support.
struct ThreePlayerRightGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width - spacing) / 2
            let height = (geometry.size.height - spacing) / 2
            
            HStack(spacing: spacing) {
                // Left side - two players stacked
                VStack(spacing: spacing) {
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 1 area"
                    )
                    
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 2 area"
                    )
                }
                
                // Right player area (full height)
                MTGPlayerAreaRepresentation(
                    width: width,
                    height: geometry.size.height,
                    playerLabel: "Player 3 area"
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Three player layout - right configuration")
        .accessibilityHint("Two players stacked on left, one player on right")
    }
}

#Preview {
    ThreePlayerRightGridView()
        .frame(width: 200, height: 120)
        .background(Color.MTG.deepBlack)
}

