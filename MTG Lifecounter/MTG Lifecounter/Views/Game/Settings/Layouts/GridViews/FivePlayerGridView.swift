//
//  FivePlayerGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for five-player layout selection.
/// Shows the arrangement where players are positioned in a 2-2-1 formation.
/// Follows MTG theming with mystical backgrounds and proper accessibility support.
struct FivePlayerGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width - 2 * spacing) / 3
            let height = (geometry.size.height - spacing) / 2
            
            HStack(spacing: spacing) {
                // Left column - two players stacked
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
                
                // Middle column - two players stacked
                VStack(spacing: spacing) {
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 3 area"
                    )
                    
                    MTGPlayerAreaRepresentation(
                        width: width,
                        height: height,
                        playerLabel: "Player 4 area"
                    )
                }
                
                // Right column - one player (full height)
                MTGPlayerAreaRepresentation(
                    width: width,
                    height: geometry.size.height,
                    playerLabel: "Player 5 area"
                )
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Five player layout")
        .accessibilityHint("Five players arranged in columns: two pairs on left and middle, one player on right")
    }
}

#Preview {
    FivePlayerGridView()
        .frame(width: 200, height: 120)
        .background(Color.MTG.deepBlack)
}
