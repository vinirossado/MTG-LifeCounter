//
//  TwoPlayerGridView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

/// A visual representation component for two-player layout selection.
/// Shows the arrangement where players are positioned side by side.
/// Follows MTG theming and accessibility guidelines.
struct TwoPlayerGridView: View {
    
    // MARK: - Constants
    private let spacing: CGFloat = MTGSpacing.xs
    
    var body: some View {
        GeometryReader { geometry in
            let width = (geometry.size.width - spacing) / 2
            let height = geometry.size.height
            
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
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Two player layout")
        .accessibilityHint("Two players positioned side by side")
    }
}

#Preview {
    TwoPlayerGridView()
        .frame(width: 200, height: 100)
        .background(Color.MTG.deepBlack)
}

