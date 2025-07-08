//
//  ThreePlayerLeftGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for three-player layout selection.
/// Shows the arrangement where one player takes the left side and two players split the right.
/// Follows MTG theming with mystical backgrounds and proper accessibility support.
struct ThreePlayerLeftGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width - spacing) / 2
            let height = (geometry.size.height - spacing) / 2
            
            HStack(spacing: spacing) {
                // Left player area (full height)
                MTGPlayerAreaRepresentation(
                    width: width,
                    height: geometry.size.height,
                    playerLabel: "Player 1 area"
                )
                
                // Right side - two players stacked
                VStack(spacing: spacing) {
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 2 area"
                    )
                    
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 3 area"
                    )
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Three player layout - left configuration")
        .accessibilityHint("One player on left, two players stacked on right")
    }
}

#Preview {
    ThreePlayerLeftGridView()
        .frame(width: 200, height: 120)
        .background(Color.MTG.deepBlack)
}
