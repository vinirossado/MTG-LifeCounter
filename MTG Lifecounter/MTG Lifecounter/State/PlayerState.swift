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
    public var commanderName: String?
    public var commanderImageURL: String?
    public var commanderArtworkURL: String?
    public var commanderColors: [String]?
    public var commanderTypeLine: String?
    public var useCommanderAsBackground: Bool = false
    public var commanderDamage: [String: Int] = [:] // Tracks damage from each opponent's commander by player name
    public var poisonCounters: Int = 0
    
    public init(HP: Int, name: String, commanderName: String? = nil, commanderImageURL: String? = nil, commanderArtworkURL: String? = nil, commanderColors: [String]? = nil, commanderTypeLine: String? = nil, useCommanderAsBackground: Bool = false, commanderDamage: [String: Int] = [:], poisonCounters: Int = 0) {
        self.HP = HP
        self.name = name
        self.commanderName = commanderName
        self.commanderImageURL = commanderImageURL
        self.commanderArtworkURL = commanderArtworkURL
        self.commanderColors = commanderColors
        self.commanderTypeLine = commanderTypeLine
        self.useCommanderAsBackground = useCommanderAsBackground
        self.commanderDamage = commanderDamage
        self.poisonCounters = poisonCounters
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
