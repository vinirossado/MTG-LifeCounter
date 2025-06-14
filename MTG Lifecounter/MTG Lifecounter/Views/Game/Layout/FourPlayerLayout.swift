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
        VStack(spacing: 10) {
            if playerState.players.count >= 4 {
                HStack(spacing: 10) {
                    if let player1 = playerState.bindingForPlayer(at: 0) {
                        PlayerView(player: player1, orientation: .inverted)
                    }
                    
                    if let player2 = playerState.bindingForPlayer(at: 1) {
                        PlayerView(player: player2, orientation: .inverted)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 10) {
                    if let player3 = playerState.bindingForPlayer(at: 2) {
                        PlayerView(player: player3, orientation: .normal)
                    }
                    
                    if let player4 = playerState.bindingForPlayer(at: 3) {
                        PlayerView(player: player4, orientation: .normal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Not enough players for this layout")
            }
        }
    }
}

