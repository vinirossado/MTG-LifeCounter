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

  private var headerBackground: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.black.opacity(0.8))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.white.opacity(0.2), lineWidth: 1)
      )
  }

  private var headerSection: some View {
    VStack(spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: "crown.fill")
          .font(.title3)
          .foregroundColor(.yellow)

        Text("Commander Damage")
          .font(.title3)
          .fontWeight(.bold)
          .foregroundColor(.white)

        Image(systemName: "crown.fill")
          .font(.title3)
          .foregroundColor(.yellow)
      }

      Text("Track damage from enemy commanders • Changes save automatically")
        .font(.caption)
        .foregroundColor(.gray)
        .multilineTextAlignment(.center)
    }
    .padding(.vertical, 16)
    .padding(.horizontal, 20)
    .background(headerBackground)
  }

  private var pullIndicator: some View {
    RoundedRectangle(cornerRadius: 2)
      .fill(Color.white.opacity(0.6))
      .frame(width: 40, height: 5)
      .padding(.top, 8)
  }

  var body: some View {
    ZStack {
      backgroundView
        .onTapGesture {
          dismissWithAnimation()
        }

      mainContentView
    }
    .onAppear {
      setupInitialValues()
      withAnimation(Animation.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
        animateAppear = true
      }
    }
  }

  private var mainContentView: some View {
    VStack(spacing: 0) {
      pullIndicator
      headerSection
      modernScrollContent
    }
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(Color.black.opacity(0.95))
        .shadow(color: .black.opacity(0.5), radius: 20, x: 0, y: 10)
    )
    .padding(.horizontal, 16)
    .padding(.bottom, 40)
  }

  private var modernScrollContent: some View {
    ScrollView {
      VStack(spacing: 24) {
        commanderDamageSection
        poisonCountersSection
      }
      .padding(.horizontal, 20)
    }
    .frame(maxHeight: 450)
  }

  private var commanderDamageSection: some View {
    VStack(spacing: 16) {
      commanderDamageCards
    }
  }

  private var commanderDamageSectionHeader: some View {
    HStack {
      HStack(spacing: 8) {
        Image(systemName: "bolt.circle.fill")
          .foregroundColor(.orange)
          .font(.title3)
        
        VStack(alignment: .leading, spacing: 2) {
          Text("Commander Damage")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.white)
          
          Text("Track damage from each commander")
            .font(.caption2)
            .foregroundColor(.gray)
        }
      }
      Spacer()
    }
    .padding(.horizontal, 4)
  }

  private var commanderDamageCards: some View {
    LazyVStack(spacing: 12) {
      ForEach(otherPlayers) { opponent in
        commanderDamageCard(for: opponent)
      }
    }
  }

  private func commanderDamageCard(for opponent: Player) -> some View {
    let opponentIndex = otherPlayers.firstIndex { player in
      player.id == opponent.id
    } ?? 0
    let animationDelay = Double(opponentIndex) * 0.15
    
    return ModernCommanderDamageCard(
      opponent: opponent,
      damage: tempCommanderDamage[opponent.id.uuidString] ?? 0,
      onDamageChanged: { newValue in
        tempCommanderDamage[opponent.id.uuidString] = newValue
        // Apply changes immediately
        player.commanderDamage[opponent.id.uuidString] = newValue
      }
    )
    .scaleEffect(animateAppear ? 1.0 : 0.85)
    .opacity(animateAppear ? 1.0 : 0.0)
    .animation(
      Animation.spring(response: 0.6, dampingFraction: 0.7).delay(animationDelay),
      value: animateAppear
    )
  }

  private var poisonCountersSection: some View {
    VStack(spacing: 16) {
      HStack {
        HStack(spacing: 8) {
          Image(systemName: "drop.circle.fill")
            .foregroundColor(tempPoisonCounters >= 10 ? .red : .green)
            .font(.title3)
          
          VStack(alignment: .leading, spacing: 2) {
            Text("Poison Counters")
              .font(.headline)
              .fontWeight(.bold)
              .foregroundColor(.white)
            
            Text("You lose at 10 poison counters")
              .font(.caption2)
              .foregroundColor(tempPoisonCounters >= 10 ? .red : .gray)
          }
        }
        Spacer()
      }
      .padding(.horizontal, 4)

      ModernPoisonCounterCard(
        counters: tempPoisonCounters,
        onCountersChanged: { newValue in
          tempPoisonCounters = newValue
          // Apply changes immediately
          player.poisonCounters = newValue
        }
      )
      .scaleEffect(animateAppear ? 1.0 : 0.85)
      .opacity(animateAppear ? 1.0 : 0.0)
      .animation(
        Animation.spring(response: 0.6, dampingFraction: 0.7).delay(Double(otherPlayers.count) * 0.15 + 0.2),
        value: animateAppear
      )
    }
  }

  private func setupInitialValues() {
    // Initialize temp values with current player values using player IDs
    tempCommanderDamage = player.commanderDamage
    tempPoisonCounters = player.poisonCounters
  }

  private func dismissWithAnimation() {
    withAnimation(Animation.easeIn(duration: 0.2)) {
      animateAppear = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      onDismiss()
    }
  }
}

// MARK: - Modern Commander Damage Card
struct ModernCommanderDamageCard: View {
  let opponent: Player
  let damage: Int
  let onDamageChanged: (Int) -> Void
  
  var body: some View {
    HStack(spacing: 16) {
      // Player info section
      HStack(spacing: 12) {
        // Player avatar or commander artwork
        ZStack {
          if let artworkURL = opponent.commanderImageURL,
             let url = URL(string: artworkURL) {
            AsyncImage(url: url) { phase in
              switch phase {
              case .success(let image):
                image
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 50, height: 50)
                  .clipShape(RoundedRectangle(cornerRadius: 10))
                  .overlay(
                    RoundedRectangle(cornerRadius: 10)
                      .stroke(Color.white.opacity(0.2), lineWidth: 1)
                  )
              case .failure(_), .empty:
                defaultPlayerAvatar
              @unknown default:
                defaultPlayerAvatar
              }
            }
          } else {
            defaultPlayerAvatar
          }
        }
        
        VStack(alignment: .leading, spacing: 4) {
          Text(opponent.name)
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .lineLimit(1)
          
          if let commanderName = opponent.commanderName {
            Text(commanderName)
              .font(.system(size: 13, weight: .medium))
              .foregroundColor(.gray)
              .lineLimit(1)
          } else {
            Text("No Commander")
              .font(.system(size: 13, weight: .medium))
              .foregroundColor(.gray.opacity(0.7))
              .italic()
          }
          
          // Damage status indicator
          HStack(spacing: 4) {
            Circle()
              .fill(damage >= 21 ? Color.red : (damage > 0 ? Color.orange : Color.green))
              .frame(width: 6, height: 6)
            
            Text(damage >= 21 ? "LETHAL" : (damage > 0 ? "DAMAGED" : "SAFE"))
              .font(.system(size: 10, weight: .bold))
              .foregroundColor(damage >= 21 ? .red : (damage > 0 ? .orange : .green))
          }
        }
      }
      
      Spacer()
      
      // Damage counter section
      HStack(spacing: 12) {
        // Minus button
        Button(action: {
          let newValue = max(0, damage - 1)
          onDamageChanged(newValue)
        }) {
          Image(systemName: "minus.circle.fill")
            .font(.system(size: 32))
            .foregroundColor(damage > 0 ? .red : .gray.opacity(0.5))
        }
        .disabled(damage <= 0)
        
        // Damage display
        VStack(spacing: 2) {
          Text("\(damage)")
            .font(.system(size: 24, weight: .black, design: .rounded))
            .foregroundColor(damage >= 21 ? .red : .white)
            .frame(minWidth: 40)
          
          Text("DMG")
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
          RoundedRectangle(cornerRadius: 10)
            .fill(damage >= 21 ? Color.red.opacity(0.2) : Color.black.opacity(0.4))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(
                  damage >= 21 ? Color.red.opacity(0.6) : Color.white.opacity(0.2),
                  lineWidth: 1.5
                )
            )
        )
        .shadow(
          color: damage >= 21 ? Color.red.opacity(0.3) : Color.clear,
          radius: damage >= 21 ? 6 : 0
        )
        
        // Plus button
        Button(action: {
          let newValue = damage + 1
          onDamageChanged(newValue)
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
  
  private var defaultPlayerAvatar: some View {
    RoundedRectangle(cornerRadius: 10)
      .fill(
        LinearGradient(
          colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.8)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .frame(width: 50, height: 50)
      .overlay(
        Image(systemName: "person.fill")
          .font(.system(size: 20))
          .foregroundColor(.white.opacity(0.7))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.white.opacity(0.2), lineWidth: 1)
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
