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
  @State private var isDying = false
  @State private var isDead = false
  @State private var lowHealthPulse = false

  var body: some View {
    // Defensive check: ensure playerState has been properly initialized
    let safeAllPlayers = playerState.players.isEmpty ? [player] : playerState.players
    
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
          allPlayers: safeAllPlayers, // Use safe array
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
          allPlayers: safeAllPlayers, // Use safe array
          updatePoints: updatePoints,
          startHoldTimer: startHoldTimer,
          stopHoldTimer: stopHoldTimer,
          orientation: orientation
        )
      }
    }
    .overlay {
      // Death animation overlay
      if isDead {
        DeathAnimationOverlay()
          .transition(.opacity)
      }
    }
    .overlay {
      // Low health warning overlay
      if player.HP <= 5 && player.HP > 0 && !isDead {
        LowHealthWarningOverlay()
          .opacity(lowHealthPulse ? 0.8 : 0.3)
          .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: lowHealthPulse)
          .allowsHitTesting(false) // Allow gestures to pass through
      }
    }
    .scaleEffect(isDying ? 0.95 : 1.0)
    .opacity(isDead ? 0.5 : 1.0)
    .animation(.easeInOut(duration: 0.3), value: isDying)
    .animation(.easeInOut(duration: 1.0), value: isDead)
    .onChange(of: player.HP) {_, newHP in
      handleHealthChange(newHP)
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
  
  private func handleHealthChange(_ newHP: Int) {
    // Handle death
    if newHP <= 0 && !isDead {
      withAnimation(.easeInOut(duration: 0.5)) {
        isDying = true
      }
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
        withAnimation(.easeInOut(duration: 1.0)) {
          isDead = true
          isDying = false
        }
      }
    }
    
    // Handle resurrection (HP goes from 0 to positive)
    if newHP > 0 && isDead {
      withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
        isDead = false
        isDying = false
      }
    }
    
    // Handle low health warning
    if newHP <= 5 && newHP > 0 && !lowHealthPulse {
      withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
        lowHealthPulse = true
      }
    } else if newHP > 5 || newHP <= 0 {
      lowHealthPulse = false
    }
  }
}

// MARK: - Death Animation Overlay
struct DeathAnimationOverlay: View {
  @State private var skullOpacity: Double = 0
  @State private var skullScale: CGFloat = 0.5
  @State private var particles: [ParticleView] = []
  
  var body: some View {
    ZStack {
      // Dark overlay
      Color.black.opacity(0.6)
        .ignoresSafeArea()
      
      // Skull icon
      Image(systemName: "skull.fill")
        .font(.system(size: 60, weight: .bold))
        .foregroundColor(.red)
        .opacity(skullOpacity)
        .scaleEffect(skullScale)
        .shadow(color: .red.opacity(0.8), radius: 20)
      
      // Particle effects
      ForEach(particles.indices, id: \.self) { index in
        particles[index]
      }
    }
    .onAppear {
      // Skull animation
      withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
        skullOpacity = 1.0
        skullScale = 1.2
      }
      
      // Create particles
      createParticles()
    }
  }
  
  private func createParticles() {
    for i in 0..<20 {
      let particle = ParticleView(
        delay: Double(i) * 0.1,
        direction: CGFloat.random(in: 0...360)
      )
      particles.append(particle)
    }
  }
}

// MARK: - Particle View
struct ParticleView: View {
  let delay: Double
  let direction: CGFloat
  @State private var offset: CGFloat = 0
  @State private var opacity: Double = 1
  
  var body: some View {
    Circle()
      .fill(Color.red.opacity(0.8))
      .frame(width: 4, height: 4)
      .offset(
        x: cos(direction * .pi / 180) * offset,
        y: sin(direction * .pi / 180) * offset
      )
      .opacity(opacity)
      .onAppear {
        withAnimation(.easeOut(duration: 2.0).delay(delay)) {
          offset = 100
          opacity = 0
        }
      }
  }
}

// MARK: - Low Health Warning Overlay
struct LowHealthWarningOverlay: View {
  var body: some View {
    ZStack {
      // Subtle inner glow effect
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color.red.opacity(0.4), lineWidth: 1)
        .background(
          RoundedRectangle(cornerRadius: 16)
            .fill(Color.red.opacity(0.03))
        )
      
      // Minimal corner indicators
      VStack {
        HStack {
          subtleWarningDot
          Spacer()
          subtleWarningDot
        }
        Spacer()
        HStack {
          subtleWarningDot
          Spacer()
          subtleWarningDot
        }
      }
      .padding(12)
    }
    .ignoresSafeArea()
    .allowsHitTesting(false) // Ensure this overlay never blocks interactions
  }
  
  private var subtleWarningDot: some View {
    Circle()
      .fill(Color.red.opacity(0.6))
      .frame(width: 8, height: 8)
      .shadow(color: .red.opacity(0.3), radius: 2, x: 0, y: 0)
  }
}
