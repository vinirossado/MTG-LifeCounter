//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI

// MARK: - Main Player View
struct PlayerView: View {
  @Binding var player: Player
  let orientation: OrientationLayout
  @EnvironmentObject var playerState: PlayerState // Add this to get access to all players

  @State private var isLeftPressed = false
  @State private var isRightPressed = false
  @State private var cumulativeChange = 0
  @State private var showChange = false
  @State private var holdTimer: Timer?
  @State private var isHoldTimerActive = false
  @State private var changeWorkItem: DispatchWorkItem?

  var body: some View {
    Group {
      if orientation == .normal || orientation == .inverted {
        HorizontalPlayerView(
          player: $player,
          isLeftPressed: $isLeftPressed,
          isRightPressed: $isRightPressed,
          cumulativeChange: $cumulativeChange,
          showChange: $showChange,
          holdTimer: $holdTimer,
          isHoldTimerActive: $isHoldTimerActive,
          changeWorkItem: $changeWorkItem,
          allPlayers: playerState.players, // Pass all players
          updatePoints: updatePoints,
          startHoldTimer: startHoldTimer,
          stopHoldTimer: stopHoldTimer,
          orientation: orientation
        )
      } else {
        VerticalPlayerView(
          player: $player,
          isLeftPressed: $isLeftPressed,
          isRightPressed: $isRightPressed,
          cumulativeChange: $cumulativeChange,
          showChange: $showChange,
          holdTimer: $holdTimer,
          isHoldTimerActive: $isHoldTimerActive,
          changeWorkItem: $changeWorkItem,
          allPlayers: playerState.players, // Pass all players
          updatePoints: updatePoints,
          startHoldTimer: startHoldTimer,
          stopHoldTimer: stopHoldTimer,
          orientation: orientation
        )
      }
    }
  }

  private func updatePoints(for side: SideEnum, amount: Int) {
    switch side {
    case .left:
      player.HP -= amount
      cumulativeChange -= amount
    case .right:
      player.HP += amount
      cumulativeChange += amount
    }

    showPointChange()
  }

  private func startHoldTimer(for side: SideEnum, amount: Int) {
    guard !isHoldTimerActive else { return }
    
    isHoldTimerActive = true
    holdTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
      updatePoints(for: side, amount: amount)
    }
  }

  private func stopHoldTimer() {
    holdTimer?.invalidate()
    holdTimer = nil
    isHoldTimerActive = false
  }

  private func showPointChange() {
    changeWorkItem?.cancel()
    showChange = true
    
    let newWorkItem = DispatchWorkItem {
      showChange = false
      cumulativeChange = 0
    }
    
    changeWorkItem = newWorkItem
    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: newWorkItem)
  }
}
