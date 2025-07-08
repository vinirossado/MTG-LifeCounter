//
//  MTGIndicatorBadge.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 8.07.2025.
//

import SwiftUI

// MARK: - MTG Indicator Item Model
struct MTGIndicatorItem: Identifiable {
    let id = UUID()
    let type: IndicatorType
    let value: Int
    let associatedPlayer: Player?
    
    enum IndicatorType {
        case commanderDamage
        case poison
        case energy
        case experience
        case plusOne
        case storm
        case monarch
        case initiative
        
        var icon: String {
            switch self {
            case .commanderDamage: return "crown.fill"
            case .poison: return "drop.triangle.fill"
            case .energy: return "bolt.fill"
            case .experience: return "star.fill"
            case .plusOne: return "plus.square.fill"
            case .storm: return "tornado"
            case .monarch: return "crown.fill"
            case .initiative: return "shield.fill"
            }
        }
        
        var color: Color {
            switch self {
            case .commanderDamage: return Color.MTG.gold
            case .poison: return Color.MTG.error
            case .energy: return Color.MTG.glowSecondary
            case .experience: return Color.MTG.gold
            case .plusOne: return Color.MTG.success
            case .storm: return Color.MTG.textSecondary
            case .monarch: return Color.MTG.gold
            case .initiative: return Color.MTG.blue
            }
        }
        
        var lethalThreshold: Int? {
            switch self {
            case .commanderDamage: return 21
            case .poison: return 10
            default: return nil
            }
        }
    }
    
    var displayText: String {
        switch type {
        case .commanderDamage:
            if let player = associatedPlayer {
                return "\(String(player.name.prefix(1)))\(value)"
            }
            return "\(value)"
        case .monarch, .initiative:
            return type == .monarch ? "M" : "I"
        default:
            return "\(value)"
        }
    }
    
    var isLethal: Bool {
        guard let threshold = type.lethalThreshold else { return false }
        return value >= threshold
    }
    
    var indicatorColor: Color {
        if isLethal {
            return Color.MTG.error
        }
        
        // Special coloring for commander damage based on value
        if type == .commanderDamage {
            return value >= 21 ? Color.MTG.error : 
                   value >= 15 ? Color.MTG.warning : 
                   Color.MTG.gold
        }
        
        return type.color
    }
}

// MARK: - Individual Indicator Badge
struct MTGIndicatorBadge: View {
    let indicator: MTGIndicatorItem
    
    var body: some View {
        HStack(spacing: MTGSpacing.xxs) {
            // Icon
            Image(systemName: indicator.type.icon)
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 12)
            
            // Value/Label
            Text(indicator.displayText)
                .font(.system(size: 9, weight: .black, design: .rounded))
                .foregroundColor(indicator.isLethal ? .white : .white)
                .frame(minWidth: 12)
        }
        .padding(.horizontal, MTGSpacing.xs)
        .padding(.vertical, MTGSpacing.xxs)
        .background(indicatorBackground)
        .clipShape(RoundedRectangle(cornerRadius: MTGCornerRadius.xs + 2))
        .shadow(
            color: indicator.isLethal ? Color.MTG.error.opacity(0.6) : indicator.indicatorColor.opacity(0.3),
            radius: indicator.isLethal ? 3 : 1,
            x: 0,
            y: 1
        )
        .scaleEffect(indicator.isLethal ? 1.05 : 1.0)
        .animation(MTGAnimation.standardSpring, value: indicator.isLethal)
    }
    
    private var indicatorBackground: some View {
        RoundedRectangle(cornerRadius: MTGCornerRadius.xs + 2)
            .fill(
                indicator.isLethal 
                    ? LinearGradient(
                        colors: [Color.MTG.error.opacity(0.8), Color.MTG.error.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    : LinearGradient(
                        colors: [indicator.indicatorColor.opacity(0.7), indicator.indicatorColor.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: MTGCornerRadius.xs + 2)
                    .stroke(
                        indicator.isLethal ? Color.MTG.error : indicator.indicatorColor,
                        lineWidth: indicator.isLethal ? 1.5 : 0.8
                    )
            )
    }
}

// MARK: - Indicator Row Container
struct MTGIndicatorRow: View {
    let indicators: [MTGIndicatorItem]
    let orientation: OrientationLayout
    
    var body: some View {
        if !indicators.isEmpty {
            HStack(spacing: MTGSpacing.xs) {
                ForEach(indicators) { indicator in
                    MTGIndicatorBadge(indicator: indicator)
                }
            }
            .padding(.horizontal, MTGSpacing.xs)
            .padding(.vertical, MTGSpacing.xs)
            .background(subtleBackground)
            .clipShape(RoundedRectangle(cornerRadius: MTGCornerRadius.sm))
            .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 2)
            .rotationEffect(orientation.toAngle())
        }
    }
    
    private var subtleBackground: some View {
        RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
            .fill(
                LinearGradient(
                    colors: [
                        Color.MTG.deepBlack.opacity(0.7),
                        Color.MTG.richBlack.opacity(0.6)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
                    .stroke(Color.MTG.textPrimary.opacity(0.2), lineWidth: 0.5)
            )
    }
}

// MARK: - Indicator Factory
struct MTGIndicatorFactory {
    
    static func createIndicators(for player: Player, allPlayers: [Player]) -> [MTGIndicatorItem] {
        var indicators: [MTGIndicatorItem] = []
        
        // Commander damage indicators
        for (opponentId, damage) in player.commanderDamage where damage > 0 {
            if let opponent = allPlayers.first(where: { $0.id.uuidString == opponentId }) {
                indicators.append(MTGIndicatorItem(
                    type: .commanderDamage,
                    value: damage,
                    associatedPlayer: opponent
                ))
            }
        }
        
        // Poison counters
        if player.poisonCounters > 0 {
            indicators.append(MTGIndicatorItem(
                type: .poison,
                value: player.poisonCounters,
                associatedPlayer: nil
            ))
        }
        
        // Energy counters
        if player.energyCounters > 0 {
            indicators.append(MTGIndicatorItem(
                type: .energy,
                value: player.energyCounters,
                associatedPlayer: nil
            ))
        }
        
        // Experience counters
        if player.experienceCounters > 0 {
            indicators.append(MTGIndicatorItem(
                type: .experience,
                value: player.experienceCounters,
                associatedPlayer: nil
            ))
        }
        
        // +1/+1 counters
        if player.plusOnePlusOneCounters > 0 {
            indicators.append(MTGIndicatorItem(
                type: .plusOne,
                value: player.plusOnePlusOneCounters,
                associatedPlayer: nil
            ))
        }
        
        // Storm count
        if player.stormCount > 0 {
            indicators.append(MTGIndicatorItem(
                type: .storm,
                value: player.stormCount,
                associatedPlayer: nil
            ))
        }
        
        // Monarch status
        if player.isMonarch {
            indicators.append(MTGIndicatorItem(
                type: .monarch,
                value: 0, // Boolean state
                associatedPlayer: nil
            ))
        }
        
        // Initiative status
        if player.hasInitiative {
            indicators.append(MTGIndicatorItem(
                type: .initiative,
                value: 0, // Boolean state
                associatedPlayer: nil
            ))
        }
        
        // Sort by importance (lethal first, then by type)
        return indicators.sorted { lhs, rhs in
            if lhs.isLethal != rhs.isLethal {
                return lhs.isLethal // Lethal indicators first
            }
            
            // Then by type priority
            let priority: [MTGIndicatorItem.IndicatorType] = [
                .commanderDamage, .poison, .monarch, .initiative, 
                .energy, .experience, .plusOne, .storm
            ]
            
            let lhsIndex = priority.firstIndex(of: lhs.type) ?? priority.count
            let rhsIndex = priority.firstIndex(of: rhs.type) ?? priority.count
            
            return lhsIndex < rhsIndex
        }
    }
}

// MARK: - Preview
#Preview("MTG Indicator Badges") {
    let samplePlayer = Player(
        HP: 15,
        name: "Alice",
        poisonCounters: 3,
        energyCounters: 5,
        experienceCounters: 2,
        isMonarch: true
    )
    
    var playerWithCommanderDamage = samplePlayer
    playerWithCommanderDamage.commanderDamage["opponent1"] = 18
    
    let allPlayers = [
        Player(HP: 20, name: "Bob"),
        playerWithCommanderDamage
    ]
    
    let indicators = MTGIndicatorFactory.createIndicators(
        for: playerWithCommanderDamage,
        allPlayers: allPlayers
    )
    
    return VStack(spacing: 20) {
        MTGIndicatorRow(indicators: indicators, orientation: .normal)
        
        // Individual badges for testing
        HStack {
            MTGIndicatorBadge(indicator: MTGIndicatorItem(
                type: .poison,
                value: 10,
                associatedPlayer: nil
            ))
            
            MTGIndicatorBadge(indicator: MTGIndicatorItem(
                type: .commanderDamage,
                value: 21,
                associatedPlayer: Player(HP: 20, name: "Enemy")
            ))
        }
    }
    .padding()
    .background(Color.MTG.deepBlack)
}
