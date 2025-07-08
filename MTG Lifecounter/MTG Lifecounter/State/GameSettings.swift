//
//  GameSettings.swift
//  MTG Lifecounter
//
//  Created by Snowye on 21/11/24.
//

import SwiftUI

// MARK: - Game Settings Protocol
protocol GameSettingsProtocol {
    var startingLife: Int { get set }
    var layout: PlayerLayouts { get set }
    
    func resetToDefaults()
    func isValidConfiguration() -> Bool
}

// MARK: - Game Format Types
public enum GameFormat: String, CaseIterable {
    case commander = "Commander"
    case standard = "Standard" 
    case modern = "Modern"
    case pioneer = "Pioneer"
    case legacy = "Legacy"
    case custom = "Custom"
    
    var defaultStartingLife: Int {
        switch self {
        case .commander:
            return 40
        case .standard, .modern, .pioneer, .legacy:
            return 20
        case .custom:
            return 20
        }
    }
    
    var recommendedPlayerCount: Int {
        switch self {
        case .commander:
            return 4
        case .standard, .modern, .pioneer, .legacy:
            return 2
        case .custom:
            return 2
        }
    }
    
    var description: String {
        switch self {
        case .commander:
            return "100-card singleton format"
        case .standard:
            return "Recent sets only"
        case .modern:
            return "Sets from 2003 onward"
        case .pioneer:
            return "Sets from 2012 onward"
        case .legacy:
            return "All legal cards"
        case .custom:
            return "Custom game rules"
        }
    }
}

// MARK: - Game Settings Implementation
public class GameSettings: ObservableObject, GameSettingsProtocol {
    
    // MARK: - Published Properties
    @Published public var startingLife: Int = 40 {
        didSet {
            validateAndClampLifeTotal()
            saveToUserDefaults()
        }
    }
    
    @Published public var layout: PlayerLayouts = .four {
        didSet {
            saveToUserDefaults()
        }
    }
    
    @Published public var gameFormat: GameFormat = .commander {
        didSet {
            // Auto-adjust starting life based on format
            if gameFormat != .custom {
                startingLife = gameFormat.defaultStartingLife
            }
            saveToUserDefaults()
        }
    }
    
    // MARK: - Constants
    private let minimumLife = 1
    private let maximumLife = 999
    private let userDefaultsKeyStartingLife = "GameSettings.StartingLife"
    private let userDefaultsKeyLayout = "GameSettings.Layout"
    private let userDefaultsKeyGameFormat = "GameSettings.GameFormat"
    
    // MARK: - Initialization
    public init() {
        loadFromUserDefaults()
    }
    
    // MARK: - Public Methods
    
    /// Resets all settings to their default values
    public func resetToDefaults() {
        startingLife = GameFormat.commander.defaultStartingLife
        layout = .four
        gameFormat = .commander
    }
    
    /// Validates the current configuration
    /// - Returns: True if the configuration is valid for gameplay
    public func isValidConfiguration() -> Bool {
        let isLifeValid = startingLife >= minimumLife && startingLife <= maximumLife
        let isLayoutValid = layout.playerCount >= 2 && layout.playerCount <= 6
        
        return isLifeValid && isLayoutValid
    }
    
    /// Applies a predefined format configuration
    /// - Parameter format: The game format to apply
    public func applyFormat(_ format: GameFormat) {
        gameFormat = format
        startingLife = format.defaultStartingLife
        
        // Suggest optimal layout for format
        let recommendedCount = format.recommendedPlayerCount
        if let recommendedLayout = PlayerLayouts.allCases.first(where: { $0.playerCount == recommendedCount }) {
            layout = recommendedLayout
        }
    }
    
    /// Gets the current configuration as a readable summary
    /// - Returns: A formatted string describing the current settings
    public func getConfigurationSummary() -> String {
        return "\(gameFormat.rawValue): \(startingLife) life, \(layout.playerCount) players"
    }
    
    // MARK: - Private Methods
    
    /// Validates and clamps the life total to acceptable bounds
    private func validateAndClampLifeTotal() {
        if startingLife < minimumLife {
            startingLife = minimumLife
        } else if startingLife > maximumLife {
            startingLife = maximumLife
        }
    }
    
    /// Saves current settings to UserDefaults for persistence
    private func saveToUserDefaults() {
        UserDefaults.standard.set(startingLife, forKey: userDefaultsKeyStartingLife)
        UserDefaults.standard.set(layout.rawValue, forKey: userDefaultsKeyLayout)
        UserDefaults.standard.set(gameFormat.rawValue, forKey: userDefaultsKeyGameFormat)
    }
    
    /// Loads saved settings from UserDefaults
    private func loadFromUserDefaults() {
        // Load starting life
        let savedLife = UserDefaults.standard.integer(forKey: userDefaultsKeyStartingLife)
        if savedLife > 0 {
            startingLife = min(max(savedLife, minimumLife), maximumLife)
        }
        
        // Load layout
        if let savedLayoutRaw = UserDefaults.standard.object(forKey: userDefaultsKeyLayout) as? String,
           let savedLayout = PlayerLayouts(rawValue: savedLayoutRaw) {
            layout = savedLayout
        }
        
        // Load game format
        if let savedFormatRaw = UserDefaults.standard.string(forKey: userDefaultsKeyGameFormat),
           let savedFormat = GameFormat(rawValue: savedFormatRaw) {
            gameFormat = savedFormat
        }
    }
}

// MARK: - PlayerLayouts Extension
extension PlayerLayouts: RawRepresentable {
    public init?(rawValue: String) {
        switch rawValue {
        case "two": self = .two
        case "threeLeft": self = .threeLeft
        case "threeRight": self = .threeRight
        case "four": self = .four
        case "five": self = .five
        case "six": self = .six
        default: return nil
        }
    }
    
    public var rawValue: String {
        switch self {
        case .two: return "two"
        case .threeLeft: return "threeLeft"
        case .threeRight: return "threeRight"
        case .four: return "four"
        case .five: return "five"
        case .six: return "six"
        }
    }
}
