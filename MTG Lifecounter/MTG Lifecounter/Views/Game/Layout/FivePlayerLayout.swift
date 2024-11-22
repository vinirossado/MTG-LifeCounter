//
//  FivePlayersLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

struct FivePlayerLayout: View {
    @EnvironmentObject var playerState: PlayerState
    
    var body: some View {
        if playerState.players.count >= 5 {
            HStack(spacing: 10) {
                VStack(spacing: 10) {
                    if let player1 = playerState.bindingForPlayer(at: 0) {
                        PlayerView(player: player1, orientation: .inverted)
                    }
                    if let player3 = playerState.bindingForPlayer(at: 2) {
                        PlayerView(player: player3, orientation: .normal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack(spacing: 10) {
                    if let player2 = playerState.bindingForPlayer(at: 1) {
                        PlayerView(player: player2, orientation: .inverted)
                    }
                    if let player4 = playerState.bindingForPlayer(at: 3) {
                        PlayerView(player: player4, orientation: .normal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                if let player5 = playerState.bindingForPlayer(at: 4) {
                    PlayerView(player: player5, orientation: .left)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        } else {
            Text("Not enough players for this layout")
        }
    }
}
