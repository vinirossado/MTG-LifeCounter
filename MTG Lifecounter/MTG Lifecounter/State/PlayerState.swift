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
        let requiredPlayerCount = gameSettings.layout.playerCount
        
        // Clear existing players first to prevent any state inconsistencies
        players.removeAll()
        
        // Create new players for the required layout
        players = (1...requiredPlayerCount).map { idx in
            Player(HP: gameSettings.startingLife, name: "Player \(idx)")
        }
        
        // Force UI update
        objectWillChange.send()
    }
    
    public func bindingForPlayer(at index: Int) -> Binding<Player>? {
        // Add extra safety check
        guard index >= 0 && index < players.count else { 
            print("Warning: Attempted to access player at index \(index) but only \(players.count) players exist")
            return nil 
        }
        
        return Binding(
            get: { self.players[index] },
            set: { self.players[index] = $0 }
        )
    }
}
