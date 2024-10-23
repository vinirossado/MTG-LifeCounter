//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI

struct Player {
    let id = UUID()
    var HP: Int
    var name: String
}

struct GameView: View {
    @State private var players: [Player] = (1...5).map { idx in Player(HP: 40, name: "Player \(idx)")}
    
    var body: some View {
        GeometryReader { geometry in
            generateLayout(geometry: geometry, itemCount: players.count)
                .padding(10)
                .edgesIgnoringSafeArea(.trailing)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }
    
    func generateLayout(geometry: GeometryProxy, itemCount: Int) -> some View {
        let layouts: [Int: [[Int]]] = [
            2: [[1, 2]],
            3: [[1, 2], [3, 2]],
            4: [[1, 2], [3, 4]],
            5: [[1, 2, 3], [4, 5, 3]],
            6: [[1, 2, 3], [4, 5, 6]]
        ]
        
        guard layouts[itemCount] != nil else {
            return AnyView(EmptyView())
        }
        
        if itemCount == 2 {
            return AnyView(
                HStack(spacing: 10) {
                    PlayerView(player: $players[0])
                    PlayerView(player: $players[1])
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        } else if itemCount == 3 {
            return AnyView(
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        PlayerView(player: $players[0])
                        PlayerView(player: $players[2])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    PlayerView(player: $players[1]) // 2
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
        } else if itemCount == 4 {
            return AnyView(
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        PlayerView(player: $players[0])
                        PlayerView(player: $players[1])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    HStack(spacing: 10) {
                        PlayerView(player: $players[2])
                        PlayerView(player: $players[3])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
        } else if itemCount == 5 {
            return AnyView(
                HStack(spacing: 10) {
                    VStack(spacing: 10) {
                        PlayerView(player: $players[0])
                        PlayerView(player: $players[2])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    VStack(spacing: 10) {
                        PlayerView(player: $players[1])
                        PlayerView(player: $players[3])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    PlayerView(player: $players[4])
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
        } else if itemCount == 6 {
            return AnyView(
                VStack(spacing: 10) {
                    HStack(spacing: 10) {
                        PlayerView(player: $players[0])
                        PlayerView(player: $players[1])
                        PlayerView(player: $players[2])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    HStack(spacing: 10) {
                        PlayerView(player: $players[3])
                        PlayerView(player: $players[4])
                        PlayerView(player: $players[5])
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
        } else {
            return AnyView(EmptyView())
        }
    }
    
}

#Preview {
    GameView()
}

