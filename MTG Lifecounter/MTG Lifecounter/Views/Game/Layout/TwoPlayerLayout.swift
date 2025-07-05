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
            // MTG themed background
            LinearGradient.MTG.mysticalBackground
                .ignoresSafeArea()
            
            if playerState.players.count >= 2 {
                HStack(spacing: 0) {
                    if let player1 = playerState.bindingForPlayer(at: 0) {
                        GeometryReader { geometry in
                            PlayerView(player: player1, orientation: .normal)
                                .frame(width: geometry.size.height, height: geometry.size.width)
                                .rotationEffect(.degrees(90))
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                    
                    // Vertical divider
                    Rectangle()
                        .fill(LinearGradient.MTG.magicalGlow)
                        .frame(width: MTGSpacing.borderWidth)
                        .opacity(0.3)
                    
                    if let player2 = playerState.bindingForPlayer(at: 1) {
                        GeometryReader { geometry in
                            PlayerView(player: player2, orientation: .normal)
                                .frame(width: geometry.size.height, height: geometry.size.width)
                                .rotationEffect(.degrees(270))
                                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                MTGErrorView(message: "Not enough players for this layout")
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
