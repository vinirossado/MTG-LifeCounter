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
        if playerState.players.count >= 2 {
            HStack(spacing: 10) {
                if let player1 = playerState.bindingForPlayer(at: 0) {
                    PlayerView(player: player1, orientation: .right)
                }
                
                if let player2 = playerState.bindingForPlayer(at: 1) {
                    PlayerView(player: player2, orientation: .left)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            Text("Not enough players for this layout")
        }
    }
}
