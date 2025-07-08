//
//  MTGPlayerAreaRepresentation.swift
//  MTG Lifecounter
//
//  Created by Refactor Assistant on 08/07/25.
//

import SwiftUI

/// A reusable component that represents a player area in layout selection views.
/// Features MTG-themed styling with mystical glows and proper accessibility support.
struct MTGPlayerAreaRepresentation: View {
    
    // MARK: - Properties
    let width: CGFloat
    let height: CGFloat
    let playerLabel: String
    
    @State private var mysticalGlow: Bool = false
    
    // MARK: - Constants
    private let cornerRadius: CGFloat = MTGCornerRadius.xs
    
    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(playerAreaGradient)
            .overlay(borderOverlay)
            .frame(width: width, height: height)
            .mtgGlow(
                color: Color.MTG.glowPrimary.opacity(0.2), 
                radius: mysticalGlow ? MTGSpacing.glowRadius : MTGSpacing.glowRadius / 2
            )
            .animation(MTGAnimation.pulse, value: mysticalGlow)
            .accessibilityLabel(playerLabel)
            .onAppear {
                startMysticalAnimation()
            }
    }
    
    // MARK: - Private Views
    
    private var playerAreaGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.MTG.cardBackground.opacity(0.6),
                Color.MTG.shadowGray.opacity(0.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(
                LinearGradient.MTG.magicalGlow.opacity(mysticalGlow ? 0.6 : 0.3),
                lineWidth: MTGSpacing.borderWidth
            )
    }
    
    // MARK: - Private Methods
    
    /// Starts the subtle mystical glow animation
    private func startMysticalAnimation() {
        withAnimation(MTGAnimation.pulse) {
            mysticalGlow = true
        }
    }
}

// MARK: - Preview
#Preview {
    MTGPlayerAreaRepresentation(
        width: 100,
        height: 80,
        playerLabel: "Player 1 area"
    )
    .frame(width: 120, height: 100)
    .background(Color.MTG.deepBlack)
}
