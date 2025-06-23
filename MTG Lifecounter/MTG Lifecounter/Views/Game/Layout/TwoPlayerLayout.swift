//
//  TwoPlayersLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

struct TwoPlayerLayout: View {
    @EnvironmentObject var playerState: PlayerState
    
    var body: some View {
        ZStack {
            LinearGradient.MTG.mysticalBackground
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                if playerState.players.count >= 2 {
                    HStack(spacing: MTGSpacing.xs) {
                        if let player1 = playerState.bindingForPlayer(at: 0) {
                            PlayerView(player: player1, orientation: .right)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        // Mystical divider line
                        Rectangle()
                            .fill(LinearGradient.MTG.magicalGlow)
                            .frame(width: MTGSpacing.borderWidth)
                            .opacity(0.3)
                        
                        if let player2 = playerState.bindingForPlayer(at: 1) {
                            PlayerView(player: player2, orientation: .left)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    MTGErrorView(message: "Not enough players for this layout")
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
