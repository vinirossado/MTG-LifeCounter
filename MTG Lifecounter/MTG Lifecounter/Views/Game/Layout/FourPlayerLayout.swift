//
//  FourPlayersLayout.swift
//  MTG Lifecounter
//
//  Created by Rossado on 22/11/24.
//

import SwiftUI

struct FourPlayerLayout: View {
    @EnvironmentObject var playerState: PlayerState
    
    var body: some View {
        ZStack {
            // MTG themed background
            LinearGradient.MTG.mysticalBackground
                .ignoresSafeArea()
            
            VStack(spacing: MTGSpacing.xs) {
                // Additional safety check to prevent index out of bounds
                if !playerState.isTransitioning && playerState.players.count == 4 {
                    // Top row players
                    HStack(spacing: MTGSpacing.xs) {
                        if let player1 = playerState.bindingForPlayer(at: 0) {
                            PlayerView(player: player1, orientation: .inverted)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        // Vertical divider
                        Rectangle()
                            .fill(LinearGradient.MTG.magicalGlow)
                            .frame(width: MTGSpacing.borderWidth)
                            .opacity(0.3)
                        
                        if let player2 = playerState.bindingForPlayer(at: 1) {
                            PlayerView(player: player2, orientation: .inverted)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // Horizontal divider
                    Rectangle()
                        .fill(LinearGradient.MTG.magicalGlow)
                        .frame(height: MTGSpacing.borderWidth)
                        .opacity(0.3)
                    
                    // Bottom row players
                    HStack(spacing: MTGSpacing.xs) {
                        if let player3 = playerState.bindingForPlayer(at: 2) {
                            PlayerView(player: player3, orientation: .normal)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        // Vertical divider
                        Rectangle()
                            .fill(LinearGradient.MTG.magicalGlow)
                            .frame(width: MTGSpacing.borderWidth)
                            .opacity(0.3)
                        
                        if let player4 = playerState.bindingForPlayer(at: 3) {
                            PlayerView(player: player4, orientation: .normal)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if playerState.isTransitioning {
                    VStack {
                        LoadingAnimation()
                        Text("Updating layout...")
                            .foregroundColor(.white.opacity(0.8))
                    }
                } else {
                    MTGErrorView(message: "Not enough players for this layout (need 4, have \(playerState.players.count))")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
    }
}

// MARK: - MTG Error View
private struct MTGErrorView: View {
    let message: String
    
    var body: some View {
        VStack(spacing: MTGSpacing.md) {
            Image(systemName: MTGIcons.warning)
                .font(.system(size: 48))
                .foregroundStyle(LinearGradient.MTG.magicalGlow)
                .mtgGlow(color: Color.MTG.warning, radius: 12)
            
            Text(message)
                .font(MTGTypography.headline)
                .foregroundColor(Color.MTG.textPrimary)
                .multilineTextAlignment(.center)
        }
        .mtgResponsivePadding()
        .mtgCardStyle()
    }
}

