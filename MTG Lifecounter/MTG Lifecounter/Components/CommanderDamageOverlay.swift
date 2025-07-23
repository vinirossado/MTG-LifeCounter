//
//  CommanderDamageOverlay.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 06.07.2025.
//

import SwiftUI

// MARK: - Commander Damage Overlay
struct CommanderDamageOverlay: View {
  @Binding var player: Player
  let allPlayers: [Player]
  let playerOrientation: OrientationLayout // Add orientation parameter
  var onDismiss: () -> Void

  @State private var animateAppear = false
  @State private var tempCommanderDamage: [String: Int] = [:]
  @State private var tempPoisonCounters = 0


  // Filter out the current player from the list
  private var otherPlayers: [Player] {
    let currentPlayerId = player.id
    return allPlayers.filter { playerState in
      playerState.id != currentPlayerId
    }
  }

  private var backgroundView: some View {
    Color.black.opacity(0.8)
      .ignoresSafeArea()
  }

  var body: some View {

    ZStack {
      backgroundView
            .onTapGesture {
                dismissWithAnimation()
                applyCommanderDamageChanges()
            }

      compactContentView
    }
    .rotationEffect(playerOrientation.toAngle()) // Apply player orientation
    .onAppear {
      setupInitialValues()

      withAnimation(Animation.spring(response: 0.4, dampingFraction: 0.8).delay(0.1)) {
        animateAppear = true
      }
    }
  }
    
    private func initializeTempCommanderDamage() {
        for opponent in otherPlayers {
            if tempCommanderDamage[opponent.id.uuidString] == nil {
                tempCommanderDamage[opponent.id.uuidString] = player.commanderDamage[opponent.id.uuidString] ?? 0
            }
        }
    }
        
    private func applyCommanderDamageChanges() {
        if player.hasPendingCommanderDamage {
            let oldTotalDamage = player.commanderDamage.values.reduce(0, +)
            let newTotalDamage = tempCommanderDamage.values.reduce(0, +)
            let damageDifference = newTotalDamage - oldTotalDamage
            
            player.commanderDamage = tempCommanderDamage
            player.HP -= damageDifference
            player.hasPendingCommanderDamage = false
            player.amountOfPendingCommanderDamage = newTotalDamage
        }
    }
    
  private var compactContentView: some View {
    VStack(spacing: 0) {
      // Enhanced header with title
      VStack(spacing: 12) {
        // Pull indicator
        RoundedRectangle(cornerRadius: 2)
          .fill(Color.white.opacity(0.6))
          .frame(width: 40, height: 4)
          .padding(.top, 8)
        
        // Title section
        HStack(spacing: 8) {
          Image(systemName: "crown.fill")
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.red)
          
          Text("Commander Damage")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
          
          Spacer()
          

        }
        .padding(.horizontal, 16)
        
        // Helper text
        Text("Track damage from each opponent's commander")
          .font(.system(size: 12, weight: .medium))
          .foregroundColor(.white.opacity(0.7))
          .padding(.horizontal, 16)
      }
      .padding(.bottom, 8)
      
      compactScrollContent
    }
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(
          LinearGradient(
            colors: [
              Color.black.opacity(0.95),
              Color.black.opacity(0.9)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .shadow(color: .black.opacity(0.4), radius: 12, x: 0, y: 6)
    )
    .padding(.horizontal, 20)
    .padding(.bottom, 50)
    .rotationEffect(playerOrientation.toAngle())

  }

  private var compactScrollContent: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        // Check if there are any opponents
        if otherPlayers.isEmpty {
          VStack(spacing: 16) {
            Image(systemName: "person.2.slash")
              .font(.system(size: 40))
              .foregroundColor(.gray.opacity(0.6))
            
            Text("No Other Players")
              .font(.system(size: 16, weight: .semibold))
              .foregroundColor(.white.opacity(0.8))
            
            Text("Commander damage is tracked between players in multiplayer games")
              .font(.system(size: 12, weight: .medium))
              .foregroundColor(.gray)
              .multilineTextAlignment(.center)
              .padding(.horizontal, 20)
          }
          .padding(.vertical, 40)
        } else {
          ForEach(otherPlayers) { opponent in
            compactCommanderDamageCard(for: opponent)
          }
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
    }
    .frame(maxHeight: 450) // Increased for better content display
  }
  
  private func compactCommanderDamageCard(for opponent: Player) -> some View {
    let opponentIndex = otherPlayers.firstIndex { player in
      player.id == opponent.id
    } ?? 0
    let animationDelay = Double(opponentIndex) * 0.15 // Slightly longer delay for better effect
    
    return CompactCommanderDamageCard(
      opponent: opponent,
      damage: tempCommanderDamage[opponent.id.uuidString] ?? (player.commanderDamage[opponent.id.uuidString] ?? 0),
      onDamageChanged: { newValue in
          print(newValue)
        tempCommanderDamage[opponent.id.uuidString] = newValue
          
          let hasChanges = tempCommanderDamage.contains {key, value in
              print(key, "chegou akey")
              print(value, "chegou avalue")
              return value != (player.commanderDamage[key] ?? 0)
          }
          
        player.hasPendingCommanderDamage = hasChanges;
          
          if hasChanges {
              player.amountOfPendingCommanderDamage = tempCommanderDamage.values.reduce(0, +)
          }
      }
    )
    .scaleEffect(animateAppear ? 1.0 : 0.9)
    .opacity(animateAppear ? 1.0 : 0.0)
    .offset(y: animateAppear ? 0 : 20)
    .animation(
      Animation.spring(response: 0.5, dampingFraction: 0.8).delay(animationDelay),
      value: animateAppear
    )
  }

  private func setupInitialValues() {
    // Initialize temp values with current player values using player IDs
//    tempCommanderDamage = player.commanderDamage
    tempPoisonCounters = player.poisonCounters
    initializeTempCommanderDamage()

  }
  
//  private func resetAllDamage() {
//    // Reset all commander damage for this player
//    tempCommanderDamage.removeAll()
//    player.commanderDamage.removeAll()
//    
//    // Haptic feedback
//    let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
//    impactFeedback.impactOccurred()
//  }
    
  private func dismissWithAnimation() {
    withAnimation(Animation.easeIn(duration: 0.15)) {
      animateAppear = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
      onDismiss()
    }
  }
}

// MARK: - Compact Commander Damage Card
struct CompactCommanderDamageCard: View {
  let opponent: Player
  let damage: Int
  let onDamageChanged: (Int) -> Void
  
  @State private var isPressed = false
  @State private var showDamageChange = false
  
  var body: some View {
    HStack(spacing: 16) {
      // Enhanced player info section
      HStack(spacing: 12) {
        // Player avatar with status indicator
        ZStack {
          Group {
            if let artworkURL = opponent.commanderImageURL,
               let url = URL(string: artworkURL) {
              AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                  image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 44, height: 44)
                    .clipShape(Circle())
                    .overlay(
                      Circle()
                        .stroke(
                          damage >= 21 ? Color.red : (damage > 0 ? Color.orange : Color.gray.opacity(0.5)),
                          lineWidth: 2
                        )
                    )
                case .failure(_), .empty:
                  compactPlayerAvatar
                @unknown default:
                  compactPlayerAvatar
                }
              }
            } else {
              compactPlayerAvatar
            }
          }
          
          // Status indicator badge
          if damage >= 21 {
            VStack {
              Spacer()
              HStack {
                Spacer()
                Circle()
                  .fill(Color.red)
                  .frame(width: 12, height: 12)
                  .overlay(
                    Image(systemName: "exclamationmark")
                      .font(.system(size: 6, weight: .bold))
                      .foregroundColor(.white)
                  )
                  .shadow(color: .red.opacity(0.6), radius: 4)
              }
            }
          }
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(opponent.name)
            .font(.system(size: 15, weight: .semibold))
            .foregroundColor(.white)
            .lineLimit(1)
          
          if let commanderName = opponent.commanderName {
            Text(commanderName)
              .font(.system(size: 11, weight: .medium))
              .foregroundColor(.white.opacity(0.7))
              .lineLimit(1)
          }
        }
      }
      
      Spacer()
      
      // Enhanced counter section
      HStack(spacing: 12) {
        // Minus button with better feedback
        Button(action: {
          let newValue = max(0, damage - 1)
          withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            onDamageChanged(newValue)
          }
          
          // Haptic feedback
          let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
          impactFeedback.impactOccurred()
        }) {
          Image(systemName: "minus.circle.fill")
            .font(.system(size: 28))
            .foregroundColor(damage > 0 ? .red : .gray.opacity(0.5))
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .disabled(damage <= 0)
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
        )
        
        // Enhanced damage display
        VStack(spacing: 2) {
          Text("\(damage)")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(damage >= 21 ? .red : .white)
            .frame(minWidth: 35)

        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(
              LinearGradient(
                colors: damage >= 21 
                  ? [Color.red.opacity(0.3), Color.red.opacity(0.2)]
                  : [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  damage >= 21 ? Color.red.opacity(0.8) : Color.gray.opacity(0.6),
                  lineWidth: 1.5
                )
            )
        )
        .shadow(
          color: damage >= 21 ? Color.red.opacity(0.4) : Color.clear,
          radius: damage >= 21 ? 6 : 0
        )
        .scaleEffect(showDamageChange ? 1.1 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: showDamageChange)
        
        // Plus button with better feedback
        Button(action: {
          let newValue = min(damage + 1, 99) // Cap at 99
          withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            onDamageChanged(newValue)
            showDamageChange = true
          }
          
          // Reset scale animation
          DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showDamageChange = false
          }
          
          // Special haptic feedback for lethal damage
          if newValue >= 21 && damage < 21 {
            let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedback.impactOccurred()
          } else {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
          }
        }) {
          Image(systemName: "plus.circle.fill")
            .font(.system(size: 28))
            .foregroundColor(.green)
            .scaleEffect(isPressed ? 0.9 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
        }
        .simultaneousGesture(
          DragGesture(minimumDistance: 0)
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
        )
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .background(
      RoundedRectangle(cornerRadius: 14)
        .fill(
          LinearGradient(
            colors: [
              Color.black.opacity(0.4),
              Color.black.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: 14)
            .stroke(
              LinearGradient(
                colors: [
                  Color.white.opacity(0.2),
                  Color.white.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 1
            )
        )
    )
    .shadow(color: .black.opacity(0.3), radius: 6, x: 0, y: 3)
  }
  
  private var compactPlayerAvatar: some View {
    Circle()
      .fill(
        LinearGradient(
          colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.8)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .frame(width: 44, height: 44)
      .overlay(
        Image(systemName: "person.fill")
          .font(.system(size: 18))
          .foregroundColor(.white.opacity(0.7))
      )
      .overlay(
        Circle()
          .stroke(
            damage >= 21 ? Color.red : (damage > 0 ? Color.orange : Color.gray.opacity(0.5)),
            lineWidth: 2
          )
      )
  }
}

// MARK: - Modern Poison Counter Card
struct ModernPoisonCounterCard: View {
  let counters: Int
  let onCountersChanged: (Int) -> Void
  
  var body: some View {
    HStack(spacing: 16) {
      // Info section
      HStack(spacing: 12) {
        ZStack {
          RoundedRectangle(cornerRadius: 10)
            .fill(
              LinearGradient(
                colors: counters >= 10 ? [Color.red.opacity(0.6), Color.red.opacity(0.8)] : [Color.green.opacity(0.6), Color.green.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .frame(width: 50, height: 50)
          
          Image(systemName: "drop.fill")
            .font(.system(size: 24))
            .foregroundColor(.white)
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text("Poison Counters")
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
          
          Text("Lose at 10 counters")
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(.gray)
          
          // Status indicator
          HStack(spacing: 4) {
            Circle()
              .fill(counters >= 10 ? Color.red : (counters > 0 ? Color.orange : Color.green))
              .frame(width: 6, height: 6)
            
            Text(counters >= 10 ? "DEFEATED" : (counters > 0 ? "POISONED" : "HEALTHY"))
              .font(.system(size: 10, weight: .bold))
              .foregroundColor(counters >= 10 ? .red : (counters > 0 ? .orange : .green))
          }
        }
      }
      
      Spacer()
      
      // Counter section
      HStack(spacing: 12) {
        // Minus button
        Button(action: {
          let newValue = max(0, counters - 1)
          onCountersChanged(newValue)
        }) {
          Image(systemName: "minus.circle.fill")
            .font(.system(size: 32))
            .foregroundColor(counters > 0 ? .red : .gray.opacity(0.5))
        }
        .disabled(counters <= 0)
        
        // Counter display
        VStack(spacing: 2) {
          Text("\(counters)")
            .font(.system(size: 24, weight: .black, design: .rounded))
            .foregroundColor(counters >= 10 ? .red : .white)
            .frame(minWidth: 40)
          
          Text("POISON")
            .font(.system(size: 9, weight: .bold))
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(counters >= 10 ? Color.red.opacity(0.3) : Color.black.opacity(0.4))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  counters >= 10 ? Color.red.opacity(0.8) : Color.white.opacity(0.2),
                  lineWidth: 1.5
                )
            )
        )
        .shadow(
          color: counters >= 10 ? Color.red.opacity(0.4) : Color.clear,
          radius: counters >= 10 ? 8 : 0
        )
        
        // Plus button
        Button(action: {
          let newValue = counters + 1
          onCountersChanged(newValue)
        }) {
          Image(systemName: "plus.circle.fill")
            .font(.system(size: 32))
            .foregroundColor(.green)
        }
      }
    }
    .padding(16)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(
          LinearGradient(
            colors: [
              Color.black.opacity(0.3),
              Color.black.opacity(0.6)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
          )
        )
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(
              LinearGradient(
                colors: [
                  Color.white.opacity(0.2),
                  Color.white.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 1
            )
        )
    )
    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
  }
}
