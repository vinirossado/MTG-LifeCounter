//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI
import UIKit

// Forward declarations of functions used in the views
typealias UpdatePointsFunc = (SideEnum, Int) -> Void
typealias TimerHandlerFunc = (SideEnum, Int) -> Void
typealias StopTimerFunc = () -> Void

// MARK: - Main Player View
public struct PlayerView: View {
  @Binding public var player: Player
  public var orientation: OrientationLayout

  @State private var isLeftPressed: Bool = false
  @State private var isRightPressed: Bool = false
  @State private var cumulativeChange: Int = 0
  @State private var showChange: Bool = false
  @State private var holdTimer: Timer?
  @State private var isHoldTimerActive: Bool = false
  @State private var changeWorkItem: DispatchWorkItem?

  public var body: some View {
    orientation == .normal || orientation == .inverted
      ? AnyView(
        HorizontalPlayerView(
          player: $player,
          isLeftPressed: $isLeftPressed,
          isRightPressed: $isRightPressed,
          cumulativeChange: $cumulativeChange,
          showChange: $showChange,
          holdTimer: $holdTimer,
          isHoldTimerActive: $isHoldTimerActive,
          changeWorkItem: $changeWorkItem,
          updatePoints: updatePoints,
          startHoldTimer: startHoldTimer,
          stopHoldTimer: stopHoldTimer,
          orientation: orientation
        )
      )
      : AnyView(
        VerticalPlayerView(
          player: $player,
          isLeftPressed: $isLeftPressed,
          isRightPressed: $isRightPressed,
          cumulativeChange: $cumulativeChange,
          showChange: $showChange,
          holdTimer: $holdTimer,
          isHoldTimerActive: $isHoldTimerActive,
          changeWorkItem: $changeWorkItem,
          updatePoints: updatePoints,
          startHoldTimer: startHoldTimer,
          stopHoldTimer: stopHoldTimer,
          orientation: orientation
        )
      )
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
    guard !isHoldTimerActive else {
      return
    }

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
