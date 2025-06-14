//
//  PlayerState.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

public struct Player: Identifiable {
    public let id = UUID()
    public var HP: Int
    public var name: String
    
    public init(HP: Int, name: String) {
        self.HP = HP
        self.name = name
    }
}

public class PlayerState: ObservableObject {
    @Published public var players: [Player] = []
    
    public func initialize(gameSettings: GameSettings) {
        players = (1...gameSettings.layout.playerCount).map{ idx in
            Player(HP: gameSettings.startingLife, name: "Player \(idx)")
        }
    }
    
    public func bindingForPlayer(at index: Int) -> Binding<Player>? {
        guard players.indices.contains(index) else { return nil }
        return Binding(
            get: { self.players[index] },
            set: { self.players[index] = $0 }
        )
    }
}
