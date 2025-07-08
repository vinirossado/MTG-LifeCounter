//
//  PlayerToolsOverlay.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 08.07.2025.
//

import SwiftUI

// MARK: - Player Tools Overlay
struct PlayerToolsOverlay: View {
  @Binding var player: Player
  let allPlayers: [Player]
  let playerOrientation: OrientationLayout
  var onDismiss: () -> Void

  @State private var animateAppear = false
  @State private var showDiceResult = false
  @State private var diceResult = 0
  @State private var coinResult = ""
  @State private var showCoinResult = false
  @State private var showCommanderDamageOverlay = false

  private var backgroundView: some View {
    Color.black.opacity(0.8)
      .ignoresSafeArea()
  }

  var body: some View {
    ZStack {
      backgroundView
        .onTapGesture {
          dismissWithAnimation()
        }

      toolsContentView
    }
    .rotationEffect(playerOrientation.toAngle())  // Apply player orientation
    .onAppear {
      withAnimation(Animation.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
        animateAppear = true
      }
    }
  }

  private var toolsContentView: some View {
    VStack(spacing: 0) {
      // Simple pull indicator
      RoundedRectangle(cornerRadius: 2)
        .fill(Color.white.opacity(0.6))
        .frame(width: 40, height: 4)
        .padding(.top, 8)
        .padding(.bottom, 12)
      
      // Helper text
      Text("Tap to increase • Long press to decrease")
        .font(.system(size: 11, weight: .medium))
        .foregroundColor(.white.opacity(0.7))
        .padding(.bottom, 16)

      toolsScrollContent
    }
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.black.opacity(0.95))
        .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
    )
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
    .overlay(
      // Commander damage overlay on top of tools overlay
      Group {
        if showCommanderDamageOverlay {
          CommanderDamageOverlay(
            player: $player,
            allPlayers: allPlayers,
            playerOrientation: playerOrientation,
            onDismiss: {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showCommanderDamageOverlay = false
              }
            }
          )
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
    )
  }

  private var toolsScrollContent: some View {
    ScrollView {
      VStack(spacing: 20) {
//        quickActionsSection

        countersSection

        diceAndRandomSection

        gameStateSection
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .frame(maxHeight: 450)  // Slightly larger for better spacing
  }

  // MARK: - Quick Actions Section
//  private var quickActionsSection: some View {
//    VStack(spacing: 12) {
//      HStack {
//        Image(systemName: "bolt.fill")
//          .foregroundColor(.yellow)
//          .font(.system(size: 14))
//        Text("Quick Life Changes")
//          .font(.system(size: 14, weight: .semibold))
//          .foregroundColor(.white)
//        Spacer()
//      }
//
//      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
//        ToolButton(
//          icon: "heart.fill",
//          title: "+1",
//          color: .green,
//          action: { adjustLife(1) }
//        )
//        
//        ToolButton(
//          icon: "heart.fill",
//          title: "+5",
//          color: .green,
//          action: { adjustLife(5) }
//        )
//
//        ToolButton(
//          icon: "heart.slash",
//          title: "-1",
//          color: .red,
//          action: { adjustLife(-1) }
//        )
//        
//        ToolButton(
//          icon: "heart.slash",
//          title: "-5",
//          color: .red,
//          action: { adjustLife(-5) }
//        )
//      }
//    }
//  }

  // MARK: - Dice & Random Section
  private var diceAndRandomSection: some View {
    VStack(spacing: 12) {
      HStack {
        Image(systemName: "dice.fill")
          .foregroundColor(.blue)
          .font(.system(size: 14))
        Text("Dice & Random")
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(.white)
        Spacer()
      }

      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
        ToolButton(
          icon: "dice",
          title: "D6",
          color: .blue,
          action: { rollDice(6) }
        )

        ToolButton(
          icon: "dice",
          title: "D20",
          color: .blue,
          action: { rollDice(20) }
        )

        ToolButton(
          icon: "circle.lefthalf.filled",
          title: "Coin Flip",
          color: .orange,
          action: { flipCoin() }
        )
      }

      // Result display
      if showDiceResult {
        resultDisplay(text: "Rolled: \(diceResult)", color: .blue)
      }

      if showCoinResult {
        resultDisplay(text: "Result: \(coinResult)", color: .orange)
      }
    }
  }

  // MARK: - Counters Section
  private var countersSection: some View {
    VStack(spacing: 12) {
      HStack {
        Image(systemName: "plus.circle.fill")
          .foregroundColor(.green)
          .font(.system(size: 14))
        Text("Counters & Damage")
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(.white)
        Spacer()
      }

      // Commander damage row
      VStack(spacing: 8) {
        ToolButton(
          icon: "crown.fill",
          title: "Commander Damage",
          color: .red,
          action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              showCommanderDamageOverlay = true
            }
          }
        )
      }
      
      // Counters grid - 2x2 layout for better spacing
      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
        ToolButton(
          icon: "drop.triangle.fill",
          title: "Poison: \(player.poisonCounters)",
          color: player.poisonCounters >= 10 ? .red : .purple,
          action: { addPoison(1) },
          longPressAction: {
            if player.poisonCounters > 0 {
              player.poisonCounters = max(0, player.poisonCounters - 1)
              let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
              impactFeedback.impactOccurred()
            }
          }
        )

        ToolButton(
          icon: "bolt.circle.fill",
          title: "Energy: \(player.energyCounters)",
          color: .cyan,
          action: { addEnergyCounters() },
          longPressAction: {
            if player.energyCounters > 0 {
              player.energyCounters = max(0, player.energyCounters - 1)
              let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
              impactFeedback.impactOccurred()
            }
          }
        )

        ToolButton(
          icon: "tornado",
          title: "Storm: \(player.stormCount)",
          color: .gray,
          action: { incrementStorm() },
          longPressAction: {
            print("🌪️ Resetting Storm count to 0")
            player.stormCount = 0
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
          }
        )

        ToolButton(
          icon: "star.fill",
          title: "Experience: \(player.experienceCounters)",
          color: .yellow,
          action: { addExperienceCounters() },
          longPressAction: {
            if player.experienceCounters > 0 {
              player.experienceCounters = max(0, player.experienceCounters - 1)
              let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
              impactFeedback.impactOccurred()
            }
          }
        )
      }
    }
  }

  // MARK: - Game State Section
  private var gameStateSection: some View {
    VStack(spacing: 12) {
      HStack {
        Image(systemName: "gamecontroller.fill")
          .foregroundColor(.purple)
          .font(.system(size: 14))
        Text("Game State")
          .font(.system(size: 14, weight: .semibold))
          .foregroundColor(.white)
        Spacer()
      }

      LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
        ToolButton(
          icon: "crown.fill",
          title: player.isMonarch ? "👑 Monarch" : "Monarchy",
          color: player.isMonarch ? .yellow : .gray,
          action: { toggleMonarch() }
        )

        ToolButton(
          icon: "shield.fill",
          title: player.hasInitiative ? "🛡️ Initiative" : "Initiative",
          color: player.hasInitiative ? .blue : .gray,
          action: { toggleInitiative() }
        )

        ToolButton(
          icon: player.isDayTime ? "sun.max.fill" : "moon.fill",
          title: player.isDayTime ? "☀️ Day" : "🌙 Night",
          color: player.isDayTime ? .orange : .purple,
          action: { toggleDayNight() }
        )
      }
    }
  }

  private func resultDisplay(text: String, color: Color) -> some View {
    HStack {
      Text(text)
        .font(.system(size: 18, weight: .bold))
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(
              LinearGradient(
                colors: [color.opacity(0.8), color.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(
                  LinearGradient(
                    colors: [color.opacity(0.9), color.opacity(0.7)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  ),
                  lineWidth: 2
                )
            )
        )
        .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
    }
    .scaleEffect(animateAppear ? 1.0 : 0.8)
    .animation(.spring(response: 0.4, dampingFraction: 0.7), value: animateAppear)
  }

  // MARK: - Actions
  private func adjustLife(_ amount: Int) {
    player.HP += amount
    // Add haptic feedback
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }

  private func addPoison(_ amount: Int) {
    player.poisonCounters = min(player.poisonCounters + amount, 99)
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
  }

  private func rollDice(_ sides: Int) {
    diceResult = Int.random(in: 1...sides)
    showDiceResult = true
    showCoinResult = false

    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    impactFeedback.impactOccurred()

    // Hide result after 3 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      withAnimation {
        showDiceResult = false
      }
    }
  }

  private func flipCoin() {
    coinResult = Bool.random() ? "Heads" : "Tails"
    showCoinResult = true
    showDiceResult = false

    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
    impactFeedback.impactOccurred()

    // Hide result after 3 seconds
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      withAnimation {
        showCoinResult = false
      }
    }
  }

  private func addEnergyCounters() {
    player.energyCounters += 1
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }

  private func addExperienceCounters() {
    player.experienceCounters += 1
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }

  private func addPlusPlusCounters() {
    player.plusOnePlusOneCounters += 1
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }

  private func toggleMonarch() {
    player.isMonarch.toggle()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
  }

  private func toggleInitiative() {
    player.hasInitiative.toggle()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
  }

  private func toggleDayNight() {
    player.isDayTime.toggle()
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    impactFeedback.impactOccurred()
  }

  private func incrementStorm() {
    player.stormCount += 1
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    impactFeedback.impactOccurred()
  }

  private func dismissWithAnimation() {
    withAnimation(Animation.easeIn(duration: 0.15)) {
      animateAppear = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      onDismiss()
    }
  }
}

// MARK: - Tool Button Component
struct ToolButton: View {
  let icon: String
  let title: String
  let color: Color
  let action: () -> Void
  let longPressAction: (() -> Void)?
  
  @State private var isPressed = false
  
  init(icon: String, title: String, color: Color, action: @escaping () -> Void, longPressAction: (() -> Void)? = nil) {
    self.icon = icon
    self.title = title
    self.color = color
    self.action = action
    self.longPressAction = longPressAction
  }

  var body: some View {
    VStack(spacing: 6) {
      HStack(spacing: 4) {
        Image(systemName: icon)
          .font(.system(size: 18, weight: .medium))
          .foregroundColor(color)
        
        // Show a small indicator if long press is available
        if longPressAction != nil {
          Image(systemName: "hand.point.up.fill")
            .font(.system(size: 7))
            .foregroundColor(color.opacity(0.7))
        }
      }

      Text(title)
        .font(.system(size: 11, weight: .semibold))
        .foregroundColor(.white)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.8)
    }
    .frame(height: 70)
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .padding(.horizontal, 12)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(
          LinearGradient(
            colors: [
              Color.black.opacity(0.5),
              Color.black.opacity(0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(
              LinearGradient(
                colors: [
                  color.opacity(0.6),
                  color.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 1.5
            )
        )
    )
    .scaleEffect(isPressed ? 0.95 : 1.0)
    .shadow(color: color.opacity(0.3), radius: isPressed ? 8 : 4, x: 0, y: 2)
    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    .onTapGesture {
      action()
    }
    .onLongPressGesture(minimumDuration: 0.5) {
      if let longPressAction = longPressAction {
        print("🌪️ Long press detected on ToolButton")
        longPressAction()
      }
    }
    .simultaneousGesture(
      DragGesture(minimumDistance: 0)
        .onChanged { _ in
          withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = true
          }
        }
        .onEnded { _ in
          withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = false
          }
        }
    )
  }
}

#Preview {
  PlayerToolsOverlay(
    player: .constant(Player(HP: 40, name: "Test Player")),
    allPlayers: [],
    playerOrientation: .normal,
    onDismiss: {}
  )
}
