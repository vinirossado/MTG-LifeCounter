//
//  CommanderDetailView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado 26.06.2025.
//

import SwiftUI

struct CommanderDetailView: View {
  let commander: ScryfallCard
  let onSelect: (ScryfallCard) -> Void
  let onSelectAsBackground: ((ScryfallCard) -> Void)?
  let playerOrientation: OrientationLayout

  @Environment(\.presentationMode) var presentationMode
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass

  @State private var isVisible = false
  @State private var mysticalGlow: Double = 0.3

  private var isIPad: Bool {
    horizontalSizeClass == .regular && verticalSizeClass == .regular
  }

  private var isLandscape: Bool {
    verticalSizeClass == .compact
  }

  init(
    commander: ScryfallCard, 
    onSelect: @escaping (ScryfallCard) -> Void,
    onSelectAsBackground: ((ScryfallCard) -> Void)? = nil,
    playerOrientation: OrientationLayout
  ) {
    self.commander = commander
    self.onSelect = onSelect
    self.onSelectAsBackground = onSelectAsBackground
    self.playerOrientation = playerOrientation
  }

  var body: some View {
    ZStack {
      Color.black.opacity(0.9)
        .ignoresSafeArea()

      GeometryReader { geometry in
        VStack {
          ScrollView {
            VStack(spacing: isIPad ? 24 : 16) {
              // Close Button
              HStack {
                Spacer()
                Button(action: {
                  withAnimation(.easeInOut(duration: 0.3)) {
                    presentationMode.wrappedValue.dismiss()
                  }
                }) {
                  Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white.opacity(0.8))
                    .background(
                      Circle()
                        .fill(Color.black.opacity(0.5))
                    )
                }
              }
              .padding(.top, 20)
              .padding(.horizontal, 20)

              // Main Content
              VStack(spacing: isIPad ? 32 : 24) {
                // Commander Card Image
                commanderImageSection(geometry: geometry)

                // Commander Info (commented out for now)
                // commanderInfoSection
              }
              .padding(.horizontal, isIPad ? 40 : 20)
            }
          }
          
          // Button fixed at bottom
          actionButtonsSection
        }
      }
    }
    .rotationEffect(playerOrientation.toAngle())
    .onAppear {
      withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
        isVisible = true
      }

      withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
        mysticalGlow = 0.6
      }
    }
  }

  // MARK: - Commander Image Section
  private func commanderImageSection(geometry: GeometryProxy) -> some View {
    VStack(spacing: 16) {
      ZStack {
        // Background card frame
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(
            LinearGradient(
              colors: [
                Color.darkNavyBackground,
                Color.oceanBlueBackground.opacity(0.95),
                Color.darkNavyBackground,
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
              .stroke(
                LinearGradient(
                  colors: [
                    Color.blue.opacity(0.6),
                    Color.purple.opacity(0.4),
                    Color.blue.opacity(0.6),
                  ],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                ),
                lineWidth: 2
              )
          )
          .shadow(color: Color.blue.opacity(mysticalGlow), radius: 20, x: 0, y: 8)

        // Commander Image
        if let imageURL = commander.imageURL {
          AsyncImage(url: URL(string: imageURL)) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(16)
                .padding(12)
                .onAppear {
                  print("✅ Commander detail image loaded: \(imageURL)")
                }
            case .failure(let error):
              VStack(spacing: 16) {
                Image(systemName: "exclamationmark.triangle")
                  .font(.system(size: 48))
                  .foregroundColor(.orange)

                Text("Failed to load image")
                  .font(.system(size: 16, design: .serif))
                  .foregroundColor(.mutedSilverText)
                  .italic()

                Text(error.localizedDescription)
                  .font(.system(size: 12))
                  .foregroundColor(.mutedSilverText)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal)
              }
              .frame(height: 300)
              .onAppear {
                print(
                  "❌ Commander detail image failed: \(imageURL) - Error: \(error.localizedDescription)"
                )
              }
            case .empty:
              VStack(spacing: 16) {
                ProgressView()
                  .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                  .scaleEffect(1.5)

                Text("Loading commander...")
                  .font(.system(size: 16, design: .serif))
                  .foregroundColor(.mutedSilverText)
                  .italic()
              }
              .frame(height: 300)
              .onAppear {
                print("🔄 Loading commander detail image: \(imageURL)")
              }
            @unknown default:
              VStack(spacing: 16) {
                Image(systemName: "person.fill.questionmark")
                  .font(.system(size: 64))
                  .foregroundColor(.mutedSilverText)

                Text("Unknown image state")
                  .font(.system(size: 16, design: .serif))
                  .foregroundColor(.mutedSilverText)
              }
              .frame(height: 300)
            }
          }
        } else {
          VStack(spacing: 16) {
            Image(systemName: "person.fill.questionmark")
              .font(.system(size: 64))
              .foregroundColor(.mutedSilverText)

            Text("No image available")
              .font(.system(size: 16, design: .serif))
              .foregroundColor(.mutedSilverText)
          }
          .frame(height: 300)
        }
      }
      .frame(maxWidth: isIPad ? 400 : min(max(geometry.size.width - 40, 200), 320))
      .scaleEffect(isVisible ? 1.0 : 0.8)
      .opacity(isVisible ? 1.0 : 0.0)
    }
  }

  // MARK: - Commander Info Section
  private var commanderInfoSection: some View {
    VStack(spacing: isIPad ? 20 : 16) {
      // Commander Name
      Text(commander.name)
        .font(.system(size: isIPad ? 32 : 24, weight: .bold, design: .serif))
        .foregroundStyle(
          LinearGradient(
            colors: [Color.white, Color.lightGrayText],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .multilineTextAlignment(.center)
        .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)

      // Type Line
      Text(commander.type_line)
        .font(.system(size: isIPad ? 18 : 16, weight: .medium, design: .serif))
        .foregroundColor(.lightGrayText)
        .multilineTextAlignment(.center)

      // Mana Cost
      if let manaCost = commander.mana_cost, !manaCost.isEmpty {
        HStack(spacing: 8) {
          Text("Mana Cost:")
            .font(.system(size: 14, weight: .semibold, design: .serif))
            .foregroundColor(.mutedSilverText)

          Text(manaCost)
            .font(.system(size: 16, weight: .bold, design: .monospaced))
            .foregroundColor(.lightGrayText)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
              RoundedRectangle(cornerRadius: 6)
                .fill(Color.oceanBlueBackground.opacity(0.4))
                .overlay(
                  RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
            )
        }
      }

      //             Color Identity
      if !commander.displayColors.isEmpty {
        VStack(spacing: 8) {
          Text("Color Identity")
            .font(.system(size: 14, weight: .semibold, design: .serif))
            .foregroundColor(.mutedSilverText)

          HStack(spacing: 8) {
            ForEach(commander.displayColors, id: \.self) { color in
              manaSymbolView(for: color)
            }
          }
        }
      }

      //             Commander Status
      VStack(spacing: 8) {
        HStack(spacing: 12) {
          if commander.isCommander {
            statusBadge(text: "Commander Legal", color: .green, icon: "checkmark.shield.fill")
          }

          if commander.isLegendaryCreature {
            statusBadge(text: "Legendary", color: .yellow, icon: "crown.fill")
          }
        }
      }
    }
    .padding(isIPad ? 24 : 16)
    .background(
      RoundedRectangle(cornerRadius: 16)
        .fill(Color.darkNavyBackground.opacity(0.6))
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(
              LinearGradient(
                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ),
              lineWidth: 1
            )
        )
    )
  }

  // MARK: - Action Buttons Section
  private var actionButtonsSection: some View {
    VStack(spacing: isIPad ? 20 : 16) {
      // Select Commander Button
      Button(action: {
        withAnimation(.easeInOut(duration: 0.3)) {
          onSelect(commander)
          presentationMode.wrappedValue.dismiss()
        }
      }) {
        HStack(spacing: 12) {
          Image(systemName: "checkmark.seal.fill")
            .font(.system(size: 18, weight: .medium))
          Text("Choose as Commander")
            .font(.system(size: isIPad ? 20 : 18, weight: .semibold, design: .serif))
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, isIPad ? 18 : 16)
        .background(
          RoundedRectangle(cornerRadius: 12)
            .fill(
              LinearGradient(
                colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
        )
        .shadow(color: Color.green.opacity(0.4), radius: 8, x: 0, y: 4)
      }
      .buttonStyle(MTGButtonStyle())
    }
    .padding(.horizontal, isIPad ? 24 : 16)
    .padding(.bottom, isIPad ? 30 : 20)  // Added bottom padding
  }

  // MARK: - Helper Views
  private func manaSymbolView(for color: String) -> some View {
    let (bgColor, symbol) = manaColorInfo(for: color)

    return Text(symbol)
      .font(.system(size: isIPad ? 18 : 16, weight: .bold))
      .foregroundColor(.white)
      .frame(width: isIPad ? 32 : 28, height: isIPad ? 32 : 28)
      .background(
        Circle()
          .fill(bgColor)
          .overlay(
            Circle()
              .stroke(Color.white.opacity(0.4), lineWidth: 1)
          )
      )
      .shadow(color: bgColor.opacity(0.5), radius: 4, x: 0, y: 2)
  }

  private func statusBadge(text: String, color: Color, icon: String) -> some View {
    HStack(spacing: 6) {
      Image(systemName: icon)
        .font(.system(size: 12, weight: .medium))
      Text(text)
        .font(.system(size: 12, weight: .semibold, design: .serif))
    }
    .foregroundColor(.white)
    .padding(.horizontal, 12)
    .padding(.vertical, 6)
    .background(
      Capsule()
        .fill(color.opacity(0.8))
        .overlay(
          Capsule()
            .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
    )
    .shadow(color: color.opacity(0.4), radius: 4, x: 0, y: 2)
  }

  private func manaColorInfo(for color: String) -> (Color, String) {
    switch color {
    case "W": return (Color.yellow, "W")
    case "U": return (Color.blue, "U")
    case "B": return (Color.black, "B")
    case "R": return (Color.red, "R")
    case "G": return (Color.green, "G")
    default: return (Color.gray, color)
    }
  }
}
