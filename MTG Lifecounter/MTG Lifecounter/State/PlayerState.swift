//
//  PlayerState.swift
//  MTG Lifecounter
//
//  Created by Snowye on 22/11/24.
//

import SwiftUI

// MARK: - Player Data Model
public struct Player: Identifiable, Codable {
    public let id = UUID()
    public var HP: Int
    public var name: String
    
    // Commander Information
    public var commanderName: String?
    public var commanderImageURL: String?
    public var commanderArtworkURL: String?
    public var commanderColors: [String]?
    public var commanderTypeLine: String?
    public var useCommanderAsBackground: Bool = false
    
    // Combat Tracking
    public var commanderDamage: [String: Int] = [:] // Tracks damage from each opponent's commander by player name
    
    // MTG Counters
    public var poisonCounters: Int = 0
    public var energyCounters: Int = 0
    public var experienceCounters: Int = 0
    public var plusOnePlusOneCounters: Int = 0
    
    // Game State Designations
    public var isMonarch: Bool = false
    public var hasInitiative: Bool = false
    public var hasCitiesBlessing: Bool = false
    
    // Turn-based State (ideally in GameState, but tracking per player for now)
    public var stormCount: Int = 0 // Storm count (resets each turn)
    public var isDayTime: Bool = true // Day/Night cycle
    
    // MARK: - Initializer
    public init(
        HP: Int,
        name: String,
        commanderName: String? = nil,
        commanderImageURL: String? = nil,
        commanderArtworkURL: String? = nil,
        commanderColors: [String]? = nil,
        commanderTypeLine: String? = nil,
        useCommanderAsBackground: Bool = false,
        commanderDamage: [String: Int] = [:],
        poisonCounters: Int = 0,
        energyCounters: Int = 0,
        experienceCounters: Int = 0,
        plusOnePlusOneCounters: Int = 0,
        isMonarch: Bool = false,
        hasInitiative: Bool = false,
        hasCitiesBlessing: Bool = false,
        stormCount: Int = 0,
        isDayTime: Bool = true
    ) {
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
        self.hasCitiesBlessing = hasCitiesBlessing
        self.stormCount = stormCount
        self.isDayTime = isDayTime
    }
}

// MARK: - Player State Protocol
protocol PlayerStateProtocol {
    var players: [Player] { get set }
    var isTransitioning: Bool { get set }
    
    func initialize(gameSettings: GameSettings)
    func bindingForPlayer(at index: Int) -> Binding<Player>?
    func resetAllPlayers(to lifeTotal: Int)
    func addPlayer(name: String, lifeTotal: Int)
    func removePlayer(at index: Int)
    func updatePlayer(at index: Int, with player: Player)
}

// MARK: - Player State Management
public class PlayerState: ObservableObject, PlayerStateProtocol {
    
    // MARK: - Published Properties
    @Published public var players: [Player] = []
    @Published public var isTransitioning: Bool = false
    
    // MARK: - Private Properties
    private let playerLifeService = PlayerLifeService()
    
    // MARK: - Public Methods
    
    /// Initializes the player state based on game settings
    /// - Parameter gameSettings: The current game configuration
    public func initialize(gameSettings: GameSettings) {
        let requiredPlayerCount = gameSettings.layout.playerCount
        
        print("🎮 Initializing PlayerState with \(requiredPlayerCount) players, \(gameSettings.startingLife) life each")
        
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
        
        print("✅ Created \(players.count) players successfully")
        
        // Clear transitioning state
        isTransitioning = false
        
        // Force another UI update to ensure new state is propagated
        objectWillChange.send()
    }
    
    /// Creates a binding for a player at a specific index with safety checks
    /// - Parameter index: The index of the player
    /// - Returns: A binding to the player, or nil if index is invalid
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
    
    /// Resets all players to a specific life total
    /// - Parameter lifeTotal: The new life total for all players
    public func resetAllPlayers(to lifeTotal: Int) {
        print("🔄 Resetting all players to \(lifeTotal) life")
        
        for index in 0..<players.count {
            playerLifeService.resetPlayerLife(&players[index], to: lifeTotal)
        }
        
        objectWillChange.send()
    }
    
    /// Adds a new player to the game
    /// - Parameters:
    ///   - name: The player's name
    ///   - lifeTotal: The starting life total
    public func addPlayer(name: String, lifeTotal: Int) {
        let newPlayer = Player(HP: lifeTotal, name: name)
        players.append(newPlayer)
        print("➕ Added player: \(name) with \(lifeTotal) life")
        objectWillChange.send()
    }
    
    /// Removes a player at the specified index
    /// - Parameter index: The index of the player to remove
    public func removePlayer(at index: Int) {
        guard index >= 0 && index < players.count else {
            print("⚠️ Cannot remove player at index \(index) - invalid index")
            return
        }
        
        let removedPlayer = players[index]
        players.remove(at: index)
        print("➖ Removed player: \(removedPlayer.name)")
        objectWillChange.send()
    }
    
    /// Updates a player at the specified index
    /// - Parameters:
    ///   - index: The index of the player to update
    ///   - player: The updated player data
    public func updatePlayer(at index: Int, with player: Player) {
        guard index >= 0 && index < players.count else {
            print("⚠️ Cannot update player at index \(index) - invalid index")
            return
        }
        
        players[index] = player
        objectWillChange.send()
    }
    
    // MARK: - Convenience Methods
    
    /// Gets the total number of players
    public var playerCount: Int {
        return players.count
    }
    
    /// Checks if the game state is ready for play
    public var isReadyForPlay: Bool {
        return !isTransitioning && playerCount >= 2 && playerCount <= 6
    }
    
    /// Validates the current player state
    /// - Returns: True if the state is valid for gameplay
    public func validateState() -> Bool {
        let hasValidPlayerCount = playerCount >= 2 && playerCount <= 6
        let allPlayersHaveValidLife = players.allSatisfy { $0.HP >= -999 && $0.HP <= 999 }
        let allPlayersHaveNames = players.allSatisfy { !$0.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        
        return hasValidPlayerCount && allPlayersHaveValidLife && allPlayersHaveNames
    }
    
    /// Gets a player by their UUID
    /// - Parameter id: The player's unique identifier
    /// - Returns: The player if found, nil otherwise
    public func getPlayer(by id: UUID) -> Player? {
        return players.first { $0.id == id }
    }
    
    /// Gets the index of a player by their UUID
    /// - Parameter id: The player's unique identifier
    /// - Returns: The player's index if found, nil otherwise
    public func getPlayerIndex(by id: UUID) -> Int? {
        return players.firstIndex { $0.id == id }
    }
}
