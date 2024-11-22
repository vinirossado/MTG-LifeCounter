//
//  SixPlayersLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

struct SixPlayerLayout: View {
    @EnvironmentObject var playerState: PlayerState
    
    var body: some View {
        if playerState.players.count == 6 {
            VStack(spacing: 10) {
                HStack(spacing: 10) {
                    if let player1 = playerState.bindingForPlayer(at: 0) {
                        PlayerView(player: player1, orientation: .inverted)
                    }
                    
                    if let player2 = playerState.bindingForPlayer(at: 1) {
                        PlayerView(player: player2, orientation: .inverted)
                    }
                    
                    if let player3 = playerState.bindingForPlayer(at: 2) {
                        PlayerView(player: player3, orientation: .inverted)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                HStack(spacing: 10) {
                    if let player4 = playerState.bindingForPlayer(at: 3) {
                        PlayerView(player: player4, orientation: .normal)
                    }
                    
                    if let player5 = playerState.bindingForPlayer(at: 4) {
                        PlayerView(player: player5, orientation: .normal)
                    }
                    
                    if let player6 = playerState.bindingForPlayer(at: 5) {
                        PlayerView(player: player6, orientation: .normal)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            Text("Not enough players for this layout")
        }
    }
}
