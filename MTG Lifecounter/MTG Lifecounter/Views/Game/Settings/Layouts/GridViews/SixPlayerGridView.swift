//
//  SixPlayerGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for six-player layout selection.
/// Shows the arrangement where players are positioned in a 3x2 grid formation.
/// Follows MTG theming with mystical backgrounds and proper accessibility support.
struct SixPlayerGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let columnWidth = (geometry.size.width - 2 * spacing) / 3
            let rowHeight = (geometry.size.height - spacing) / 2

            VStack(spacing: spacing) {
                // Top row
                HStack(spacing: spacing) {
                    ForEach(1...3, id: \.self) { playerNumber in
                        MTGPlayerAreaRepresentation(
                            width: columnWidth,
                            height: rowHeight,
                            playerLabel: "Player \(playerNumber) area"
                        )
                    }
                }
                
                // Bottom row
                HStack(spacing: spacing) {
                    ForEach(4...6, id: \.self) { playerNumber in
                        MTGPlayerAreaRepresentation(
                            width: columnWidth,
                            height: rowHeight,
                            playerLabel: "Player \(playerNumber) area"
                        )
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Six player layout")
        .accessibilityHint("Six players arranged in a 3 by 2 grid")
    }
}

#Preview {
    SixPlayerGridView()
        .frame(width: 200, height: 120)
        .background(Color.MTG.deepBlack)
}
