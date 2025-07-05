//
//  ThreePlayersLayoutLeft.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//


import SwiftUI

struct ThreePlayerLayoutLeft: View {
    @EnvironmentObject var playerState: PlayerState
    
    var body: some View {
        if playerState.players.count >= 3 {
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if let player2 = playerState.bindingForPlayer(at: 1) {
                        GeometryReader { playerGeometry in
                            PlayerView(player: player2, orientation: .normal)
                                .frame(width: playerGeometry.size.height, height: playerGeometry.size.width)
                                .rotationEffect(.degrees(90))
                                .position(x: playerGeometry.size.width / 2, y: playerGeometry.size.height / 2)
                        }
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                        .clipped()
                    }
                    
                    VStack(spacing: 0) {
                        if let player1 = playerState.bindingForPlayer(at: 0) {
                            PlayerView(player: player1, orientation: .inverted)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        
                        if let player3 = playerState.bindingForPlayer(at: 2) {
                            PlayerView(player: player3, orientation: .normal)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height)
                }
            }
            .ignoresSafeArea(.all)
        } else {
            Text("Not enough players for this layout")
        }
    }
}
