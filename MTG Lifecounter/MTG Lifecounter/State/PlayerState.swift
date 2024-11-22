//
//  PlayerState.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    var HP: Int
    var name: String
}

class PlayerState: ObservableObject {
    @Published var players: [Player] = []
    
    func initialize(gameSettings: GameSettings) {
        players = (1...gameSettings.layout.playerCount).map{ idx in
            Player(HP: gameSettings.startingLife, name: "Player \(idx)")
        }
    }
    
    func bindingForPlayer(at index: Int) -> Binding<Player>? {
        guard players.indices.contains(index) else { return nil }
        return Binding(
            get: { self.players[index] },
            set: { self.players[index] = $0 }
        )
    }
}
