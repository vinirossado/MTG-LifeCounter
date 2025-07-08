//
//  HorizontalPlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//  Refactored by Vinicius Rossado on 8.07.2025.
//

import SwiftUI

// MARK: - Legacy PressableRectangle (Backward Compatibility)
// This struct maintains compatibility with existing code while using the new MTGPressableButton internally
struct PressableRectangle: View {
    @Binding var isPressed: Bool
    @Binding var player: Player
    var side: SideEnum
    var updatePoints: (SideEnum, Int) -> Void
    var startHoldTimer: (SideEnum, Int) -> Void
    var stopHoldTimer: () -> Void

    var body: some View {
        MTGPressableButton(
            isPressed: $isPressed,
            side: side,
            onTap: { updatePoints(side, 1) },
            onLongPress: { pressing in
                if pressing {
                    startHoldTimer(side, 10)
                } else {
                    stopHoldTimer()
                }
            }
        )
    }
}

// MARK: - Horizontal Player View (Refactored)
struct HorizontalPlayerView: View {
    @Binding var player: Player
    @Binding var isLeftPressed: Bool
    @Binding var isRightPressed: Bool
    @Binding var cumulativeChange: Int
    @Binding var showChange: Bool
    @Binding var holdTimer: Timer?
    @Binding var isHoldTimerActive: Bool
    @Binding var changeWorkItem: DispatchWorkItem?
    let allPlayers: [Player]
    let updatePoints: (SideEnum, Int) -> Void
    let startHoldTimer: (SideEnum, Int) -> Void
    let stopHoldTimer: () -> Void
    var orientation: OrientationLayout

    var body: some View {
        MTGHorizontalPlayerComponent(
            player: $player,
            isLeftPressed: $isLeftPressed,
            isRightPressed: $isRightPressed,
            cumulativeChange: $cumulativeChange,
            showChange: $showChange,
            holdTimer: $holdTimer,
            isHoldTimerActive: $isHoldTimerActive,
            changeWorkItem: $changeWorkItem,
            allPlayers: allPlayers,
            updatePoints: updatePoints,
            startHoldTimer: startHoldTimer,
            stopHoldTimer: stopHoldTimer,
            orientation: orientation
        )
    }
}

// MARK: - Legacy Commander Damage Indicators (Backward Compatibility)
// Using new MTGIndicatorRow component internally
struct CommanderDamageIndicators: View {
    let player: Player
    let allPlayers: [Player]
    let geometry: GeometryProxy
    let namePosition: PlayerNamePosition
    
    var body: some View {
        let indicators = MTGIndicatorFactory.createIndicators(for: player, allPlayers: allPlayers)
        let orientation: OrientationLayout = .normal // Default orientation for compatibility
        
        if !indicators.isEmpty {
            VStack {
                if namePosition.isTop {
                    Spacer()
                    MTGIndicatorRow(indicators: indicators, orientation: orientation)
                        .padding(.bottom, MTGSpacing.sm)
                } else {
                    MTGIndicatorRow(indicators: indicators, orientation: orientation)
                        .padding(.top, MTGSpacing.sm)
                    Spacer()
                }
            }
        }
    }
}

// MARK: - Helper Functions (Maintained for Compatibility)
func getPlayerNamePosition(for orientation: OrientationLayout) -> PlayerNamePosition {
    switch orientation {
    case .normal:
        return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
    case .inverted:
        return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 180))
    case .left:
        return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 270))
    case .right:
        return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 90))
    }
}

// MARK: - Preview (Refactored)
#Preview("Horizontal Player View - Refactored") {
    HorizontalPlayerView(
        player: .constant(Player(HP: 20, name: "Player 1")),
        isLeftPressed: .constant(false),
        isRightPressed: .constant(false),
        cumulativeChange: .constant(0),
        showChange: .constant(false),
        holdTimer: .constant(nil),
        isHoldTimerActive: .constant(false),
        changeWorkItem: .constant(nil),
        allPlayers: [
            Player(HP: 20, name: "Player 1"),
            Player(HP: 20, name: "Player 2"),
            Player(HP: 20, name: "Player 3"),
            Player(HP: 20, name: "Player 4")
        ],
        updatePoints: { _, _ in },
        startHoldTimer: { _, _ in },
        stopHoldTimer: { },
        orientation: .normal
    )
    .frame(width: 300, height: 200)
    .background(Color.MTG.deepBlack)
}
