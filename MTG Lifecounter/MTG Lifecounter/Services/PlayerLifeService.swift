//
//  PlayerLifeService.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 8.07.2025.
//

import Foundation
import SwiftUI

// MARK: - Player Life Service Protocol
protocol PlayerLifeServiceProtocol {
    func updatePlayerLife(_ player: inout Player, change: Int)
    func resetPlayerLife(_ player: inout Player, to newLife: Int)
    func validateLifeChange(_ currentLife: Int, change: Int) -> Bool
    func calculateLifeZone(for life: Int, startingLife: Int) -> LifeZone
}

// MARK: - Life Zone Enumeration
enum LifeZone {
    case critical    // Life <= 5
    case danger      // Life <= 10
    case caution     // Life <= 20
    case safe        // Life > 20
    
    var color: Color {
        switch self {
        case .critical: return Color.MTG.error
        case .danger: return Color.MTG.warning
        case .caution: return Color.MTG.gold
        case .safe: return Color.MTG.success
        }
    }
    
    var description: String {
        switch self {
        case .critical: return "Critical"
        case .danger: return "Danger"
        case .caution: return "Caution"
        case .safe: return "Safe"
        }
    }
}

// MARK: - Player Life Service Implementation
class PlayerLifeService: PlayerLifeServiceProtocol {
    
    // MARK: - Constants
    private let minimumLife = -999
    private let maximumLife = 999
    
    // MARK: - Public Methods
    
    /// Updates a player's life total by the specified amount
    /// - Parameters:
    ///   - player: The player to update
    ///   - change: The amount to change (positive or negative)
    func updatePlayerLife(_ player: inout Player, change: Int) {
        guard validateLifeChange(player.HP, change: change) else {
            print("⚠️ Invalid life change: \(player.HP) + \(change)")
            return
        }
        
        let newLife = player.HP + change
        player.HP = max(minimumLife, min(maximumLife, newLife))
        
        print("✅ Player \(player.name) life updated: \(player.HP - change) → \(player.HP)")
    }
    
    /// Resets a player's life to a specific value
    /// - Parameters:
    ///   - player: The player to update
    ///   - newLife: The new life total
    func resetPlayerLife(_ player: inout Player, to newLife: Int) {
        let clampedLife = max(minimumLife, min(maximumLife, newLife))
        print("🔄 Player \(player.name) life reset: \(player.HP) → \(clampedLife)")
        player.HP = clampedLife
    }
    
    /// Validates if a life change is within acceptable bounds
    /// - Parameters:
    ///   - currentLife: Current life total
    ///   - change: Proposed change amount
    /// - Returns: True if the change is valid
    func validateLifeChange(_ currentLife: Int, change: Int) -> Bool {
        let newLife = currentLife + change
        return newLife >= minimumLife && newLife <= maximumLife
    }
    
    /// Determines the life zone for display purposes
    /// - Parameters:
    ///   - life: Current life total
    ///   - startingLife: Starting life for the game format
    /// - Returns: The appropriate life zone
    func calculateLifeZone(for life: Int, startingLife: Int) -> LifeZone {
        switch life {
        case ...5:
            return .critical
        case 6...10:
            return .danger
        case 11...20:
            return .caution
        default:
            return .safe
        }
    }
}

// MARK: - Life Change Event
struct LifeChangeEvent {
    let playerId: UUID
    let previousLife: Int
    let newLife: Int
    let change: Int
    let timestamp: Date
    let source: LifeChangeSource
    
    enum LifeChangeSource {
        case tap
        case longPress
        case manual
        case reset
        case tools
    }
}

// MARK: - Life History Service
class LifeHistoryService: ObservableObject {
    @Published private(set) var history: [LifeChangeEvent] = []
    private let maxHistorySize = 100
    
    func recordLifeChange(_ event: LifeChangeEvent) {
        history.append(event)
        
        // Keep history manageable
        if history.count > maxHistorySize {
            history.removeFirst(history.count - maxHistorySize)
        }
    }
    
    func getPlayerHistory(for playerId: UUID) -> [LifeChangeEvent] {
        return history.filter { $0.playerId == playerId }
    }
    
    func clearHistory() {
        history.removeAll()
    }
    
    func undoLastChange(for playerId: UUID) -> LifeChangeEvent? {
        guard let lastEvent = history.last(where: { $0.playerId == playerId }) else {
            return nil
        }
        
        // Remove the event from history and return it for undo
        if let index = history.lastIndex(where: { $0.playerId == playerId }) {
            history.remove(at: index)
        }
        
        return lastEvent
    }
}
