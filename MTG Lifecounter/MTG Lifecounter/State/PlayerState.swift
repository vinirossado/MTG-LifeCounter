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
    
    // New MTG counters and states
    public var energyCounters: Int = 0
    public var experienceCounters: Int = 0
    public var plusOnePlusOneCounters: Int = 0
    public var isMonarch: Bool = false
    public var hasInitiative: Bool = false
    public var hasCitiesBlessing: Bool = false
    
    // Global game state (these would ideally be in a separate GameState, but for now we'll track per player)
    public var stormCount: Int = 0 // Storm count (resets each turn)
    public var isDayTime: Bool = true // Day/Night cycle
    
    public init(HP: Int, name: String, commanderName: String? = nil, commanderImageURL: String? = nil, commanderArtworkURL: String? = nil, commanderColors: [String]? = nil, commanderTypeLine: String? = nil, useCommanderAsBackground: Bool = false, commanderDamage: [String: Int] = [:], poisonCounters: Int = 0, energyCounters: Int = 0, experienceCounters: Int = 0, plusOnePlusOneCounters: Int = 0, isMonarch: Bool = false, hasInitiative: Bool = false, stormCount: Int = 0, isDayTime: Bool = true) {
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
        self.energyCounters = energyCounters
        self.experienceCounters = experienceCounters
        self.plusOnePlusOneCounters = plusOnePlusOneCounters
        self.isMonarch = isMonarch
        self.hasInitiative = hasInitiative
        self.stormCount = stormCount
        self.isDayTime = isDayTime
    }
}

public class PlayerState: ObservableObject {
    @Published public var players: [Player] = []
    @Published public var isTransitioning: Bool = false // Add transition state
    
    public func initialize(gameSettings: GameSettings) {
        let requiredPlayerCount = gameSettings.layout.playerCount
        
        // Set transitioning state to prevent view rendering during changes
        isTransitioning = true
        
        // Clear existing players first to prevent any state inconsistencies
        players.removeAll()
        
        // Force UI update immediately to clear any existing views
        objectWillChange.send()
        
        // Create new players for the required layout
        players = (1...requiredPlayerCount).map { idx in
            Player(HP: gameSettings.startingLife, name: "Player \(idx)")
        }
        
        // Clear transitioning state
        isTransitioning = false
        
        // Force another UI update to ensure new state is propagated
        objectWillChange.send()
    }
    
    public func bindingForPlayer(at index: Int) -> Binding<Player>? {
        // Add extra safety check with detailed logging for debugging
        guard index >= 0 && index < players.count else { 
            print("⚠️ Warning: Attempted to access player at index \(index) but only \(players.count) players exist")
            print("📝 Debug: Current player count: \(players.count)")
            if !players.isEmpty {
                print("📝 Debug: Available player indices: 0 to \(players.count - 1)")
            }
            return nil 
        }
        
        return Binding(
            get: { 
                guard index >= 0 && index < self.players.count else {
                    print("⚠️ WARNING: bindingForPlayer get access out of bounds - index: \(index), count: \(self.players.count)")
                    return Player(HP: 20, name: "Player \(index + 1)")
                }
                return self.players[index] 
            },
            set: { newValue in
                guard index >= 0 && index < self.players.count else {
                    print("⚠️ WARNING: bindingForPlayer set access out of bounds - index: \(index), count: \(self.players.count)")
                    return
                }
                self.players[index] = newValue
            }
        )
    }
}
