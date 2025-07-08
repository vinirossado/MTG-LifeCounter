//
//  FourPlayerGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for four-player layout selection.
/// Shows the arrangement where players are positioned in a 2x2 grid formation.
/// Follows MTG theming with mystical backgrounds and proper accessibility support.
struct FourPlayerGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width - spacing) / 2
            let height = (geometry.size.height - spacing) / 2

            VStack(spacing: spacing) {
                // Top row
                HStack(spacing: spacing) {
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
                
                // Bottom row
                HStack(spacing: spacing) {
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
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Four player layout")
        .accessibilityHint("Four players arranged in a 2 by 2 grid")
    }
}

#Preview {
    FourPlayerGridView()
        .frame(width: 200, height: 120)
        .background(Color.MTG.deepBlack)
}
