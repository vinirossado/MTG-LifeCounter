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
    allPlayers.filter { $0.id != player.id }
  }

  private var backgroundView: some View {
    Color.black.opacity(0.8)
      .ignoresSafeArea()
  }

  private var headerBackground: some View {
    RoundedRectangle(cornerRadius: 12)
      .fill(Color.darkNavyBackground.opacity(0.8))
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(Color.white.opacity(0.2), lineWidth: 1)
      )
  }

  private var headerSection: some View {
    VStack(spacing: 8) {
      HStack {
        Image(systemName: "crown.fill")
          .font(.title2)
          .foregroundColor(.yellow)

        Text("Commander Damage")
          .font(.title2)
          .fontWeight(.semibold)
          .foregroundColor(.white)

        Image(systemName: "crown.fill")
          .font(.title2)
          .foregroundColor(.yellow)
      }

      Text("Track damage from enemy commanders")
        .font(.caption)
        .foregroundColor(.gray)
    }
    .padding()
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
      withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
        animateAppear = true
      }
    }
  }

  private var mainContentView: some View {
    VStack(spacing: 20) {
      pullIndicator

      headerSection

      ScrollView {
        VStack(spacing: 16) {
          // Commander damage section
          VStack(spacing: 12) {
            HStack {
              Image(systemName: "bolt.fill")
                .foregroundColor(.orange)
              Text("Commander Damage")
                .font(.headline)
                .foregroundColor(.white)
              Spacer()
            }

            ForEach(otherPlayers) { opponent in
              let animationDelay =
                Double(otherPlayers.firstIndex(where: { $0.id == opponent.id }) ?? 0) * 0.1
              CommanderDamageRow(
                opponentName: opponent.name,
                commanderName: opponent.commanderName ?? "Unknown Commander",
                damage: tempCommanderDamage[opponent.name] ?? 0,
                onDamageChanged: { newValue in
                  tempCommanderDamage[opponent.name] = newValue
                }
              )
              .scaleEffect(animateAppear ? 1.0 : 0.8)
              .opacity(animateAppear ? 1.0 : 0.0)
              .animation(
                .spring(response: 0.6, dampingFraction: 0.6).delay(animationDelay),
                value: animateAppear)
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.darkNavyBackground.opacity(0.6))
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(Color.white.opacity(0.15), lineWidth: 1)
              )
          )

          // Poison counters section
          VStack(spacing: 12) {
            HStack {
              Image(systemName: "drop.fill")
                .foregroundColor(.green)
              Text("Poison Counters")
                .font(.headline)
                .foregroundColor(.white)
              Spacer()
            }

            PoisonCounterRow(
              counters: tempPoisonCounters,
              onCountersChanged: { newValue in
                tempPoisonCounters = newValue
              }
            )
            .scaleEffect(animateAppear ? 1.0 : 0.8)
            .opacity(animateAppear ? 1.0 : 0.0)
            .animation(
              .spring(response: 0.6, dampingFraction: 0.6).delay(
                Double(otherPlayers.count) * 0.1 + 0.2), value: animateAppear)
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 12)
              .fill(Color.darkNavyBackground.opacity(0.6))
              .overlay(
                RoundedRectangle(cornerRadius: 12)
                  .stroke(Color.white.opacity(0.15), lineWidth: 1)
              )
          )

          // Action buttons
          HStack(spacing: 16) {
            Button("Cancel") {
              dismissWithAnimation()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )

            Button("Apply") {
              applyChanges()
              dismissWithAnimation()
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
              RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.8))
            )
          }
          .padding()
        }
      }
      .frame(maxHeight: 400)
    }
  }

  private func setupInitialValues() {
    // Initialize temp values with current player values
    tempCommanderDamage = player.commanderDamage
    tempPoisonCounters = player.poisonCounters
  }

  private func dismissWithAnimation() {
    withAnimation(.easeIn(duration: 0.2)) {
      animateAppear = false
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
      onDismiss()
    }
  }

  private func applyChanges() {
    player.commanderDamage = tempCommanderDamage
    player.poisonCounters = tempPoisonCounters
  }
}

// MARK: - Commander Damage Row
struct CommanderDamageRow: View {
  let opponentName: String
  let commanderName: String
  let damage: Int
  let onDamageChanged: (Int) -> Void

  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        Text(opponentName)
          .font(.callout)
          .foregroundColor(.white)
          .fontWeight(.semibold)

        Text(commanderName)
          .font(.caption)
          .foregroundColor(.gray)
          .lineLimit(1)
      }

      Spacer()

      HStack(spacing: 8) {
        // Minus button
        Button("-") {
          let newValue = max(0, damage - 1)
          onDamageChanged(newValue)
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(Color.red.opacity(0.8))
        )

        // Damage display
        Text("\(damage)")
          .font(.headline)
          .foregroundColor(.white)
          .fontWeight(.bold)
          .frame(minWidth: 30)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .fill(Color.black.opacity(0.4))
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(Color.white.opacity(0.3), lineWidth: 1)
              )
          )

        // Plus button
        Button("+") {
          let newValue = damage + 1
          onDamageChanged(newValue)
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(Color.green.opacity(0.8))
        )
      }
    }
    .padding(.vertical, 4)
  }
}

// MARK: - Poison Counter Row
struct PoisonCounterRow: View {
  let counters: Int
  let onCountersChanged: (Int) -> Void

  var body: some View {
    HStack(spacing: 12) {
      VStack(alignment: .leading, spacing: 2) {
        Text("Poison Counters")
          .font(.callout)
          .foregroundColor(.white)
          .fontWeight(.semibold)

        Text("You lose at 10 poison counters")
          .font(.caption)
          .foregroundColor(counters >= 10 ? .red : .gray)
          .lineLimit(1)
      }

      Spacer()

      HStack(spacing: 8) {
        // Minus button
        Button("-") {
          let newValue = max(0, counters - 1)
          onCountersChanged(newValue)
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(Color.red.opacity(0.8))
        )

        // Counter display
        Text("\(counters)")
          .font(.headline)
          .foregroundColor(counters >= 10 ? .red : .white)
          .fontWeight(.bold)
          .frame(minWidth: 30)
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .background(
            RoundedRectangle(cornerRadius: 6)
              .fill(counters >= 10 ? Color.red.opacity(0.2) : Color.black.opacity(0.4))
              .overlay(
                RoundedRectangle(cornerRadius: 6)
                  .stroke(
                    counters >= 10 ? Color.red.opacity(0.6) : Color.white.opacity(0.3),
                    lineWidth: 1
                  )
              )
          )
          .shadow(
            color: counters >= 10 ? Color.red.opacity(0.5) : Color.clear,
            radius: counters >= 10 ? 4 : 0
          )

        // Plus button
        Button("+") {
          let newValue = counters + 1
          onCountersChanged(newValue)
        }
        .font(.headline)
        .foregroundColor(.white)
        .frame(width: 32, height: 32)
        .background(
          Circle()
            .fill(Color.green.opacity(0.8))
        )
      }
    }
    .padding(.vertical, 4)
  }
}
