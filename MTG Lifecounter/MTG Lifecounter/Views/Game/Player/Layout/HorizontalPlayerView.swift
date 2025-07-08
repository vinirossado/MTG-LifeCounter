//
//  HorizontalPlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

struct PressableRectangle: View {
  @Binding var isPressed: Bool
  @Binding var player: Player
  var side: SideEnum
  var updatePoints: (SideEnum, Int) -> Void
  var startHoldTimer: (SideEnum, Int) -> Void
  var stopHoldTimer: () -> Void
  @State private var subtlePulse: Double = 0.1

  private var rectangleGradient: LinearGradient {
    let colors = side == .left 
      ? [DEFAULT_STYLES.background.opacity(0.6), Color.darkNavyBackground.opacity(0.7)]
      : [DEFAULT_STYLES.background.opacity(0.6), Color.darkNavyBackground.opacity(0.5)]
    
    return LinearGradient(
      colors: colors,
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  var body: some View {
    Rectangle()
      .fill(rectangleGradient)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .opacity(isPressed ? DEFAULT_STYLES.hoverOpacity : DEFAULT_STYLES.opacity)
      .overlay(
        // Subtle card-frame inspired corners
        Rectangle()
          .stroke(
            LinearGradient(
              colors: [
                Color.white.opacity(0.15),
                Color.blue.opacity(0.1),
                Color.white.opacity(0.15)
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: 1.5
          )
      )
      .overlay(
        // Mystical glow on press with mana-like colors
        Rectangle()
          .stroke(
            LinearGradient(
              colors: isPressed 
                ? (side == .left 
                    ? [Color.blue.opacity(0.8), Color.cyan.opacity(0.6)]
                    : [Color.red.opacity(0.9), Color.yellow.opacity(0.7)])
                : [Color.clear, Color.clear],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: isPressed ? 3 : 0
          )
          .scaleEffect(isPressed ? 0.96 : 1.0)
          .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isPressed)
      )
      .overlay(
        // Subtle mana-inspired corner decorations
        VStack {
          HStack {
            // Top-left corner decoration
            Circle()
              .fill(
                LinearGradient(
                  colors: side == .left 
                    ? [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)]
                    : [Color.red.opacity(0.3), Color.orange.opacity(0.2)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 8, height: 8)
              .opacity(isPressed ? 0.8 : 0.3)
              .shadow(
                color: side == .left ? Color.blue.opacity(subtlePulse) : Color.red.opacity(subtlePulse),
                radius: 4,
                x: 0,
                y: 0
              )
            
            Spacer()
            
            // Top-right corner decoration
            Circle()
              .fill(
                LinearGradient(
                  colors: side == .left 
                    ? [Color.cyan.opacity(0.2), Color.blue.opacity(0.3)]
                    : [Color.orange.opacity(0.2), Color.red.opacity(0.3)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 8, height: 8)
              .opacity(isPressed ? 0.8 : 0.3)
              .shadow(
                color: side == .left ? Color.blue.opacity(subtlePulse) : Color.red.opacity(subtlePulse),
                radius: 4,
                x: 0,
                y: 0
              )
          }
          
          Spacer()
          
          HStack {
            // Bottom-left corner decoration
            Circle()
              .fill(
                LinearGradient(
                  colors: side == .left 
                    ? [Color.blue.opacity(0.3), Color.cyan.opacity(0.2)]
                    : [Color.red.opacity(0.3), Color.orange.opacity(0.2)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 8, height: 8)
              .opacity(isPressed ? 0.8 : 0.3)
              .shadow(
                color: side == .left ? Color.blue.opacity(subtlePulse) : Color.red.opacity(subtlePulse),
                radius: 4,
                x: 0,
                y: 0
              )
            
            Spacer()
            
            // Bottom-right corner decoration
            Circle()
              .fill(
                LinearGradient(
                  colors: side == .left 
                    ? [Color.cyan.opacity(0.2), Color.blue.opacity(0.3)]
                    : [Color.orange.opacity(0.2), Color.red.opacity(0.3)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 8, height: 8)
              .opacity(isPressed ? 0.8 : 0.3)
              .shadow(
                color: side == .left ? Color.blue.opacity(subtlePulse) : Color.red.opacity(subtlePulse),
                radius: 4,
                x: 0,
                y: 0
              )
          }
        }
        .padding(12)
      )
      .scaleEffect(isPressed ? 0.98 : 1.0)
      .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
      .onAppear {
        // Very subtle continuous pulse for ambiance
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
          subtlePulse = 0.3
        }
      }
      .onTapGesture {
        // Enhanced tap feedback
        withAnimation(.easeInOut(duration: 0.15)) {
          isPressed = true
        }
        
        updatePoints(side, 1)
        
        // Quick visual feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
          withAnimation(.easeInOut(duration: 0.1)) {
            isPressed = false
          }
        }
      }
      .onLongPressGesture(
        minimumDuration: 0.2, maximumDistance: 0.4,
        pressing: { pressing in
          withAnimation {
            isPressed = pressing
          }

          if pressing {
            startHoldTimer(side, 10)
          } else {
            stopHoldTimer()
          }

        }, perform: {})
  }
}

// MARK: - Horizontal Player View
struct HorizontalPlayerView: View {
  @Binding var player: Player
  @Binding var isLeftPressed: Bool
  @Binding var isRightPressed: Bool
  @Binding var cumulativeChange: Int
  @Binding var showChange: Bool
  @Binding var holdTimer: Timer?
  @Binding var isHoldTimerActive: Bool
  @Binding var changeWorkItem: DispatchWorkItem?
  let allPlayers: [Player] // Add this to get access to all players
  let updatePoints: (SideEnum, Int) -> Void
  let startHoldTimer: (SideEnum, Int) -> Void
  let stopHoldTimer: () -> Void
  var orientation: OrientationLayout
  @State private var showEditSheet = false
  @State private var showOverlay = false
  @State private var showCommanderDamageOverlay = false

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Commander artwork background if enabled (behind everything)
        if player.useCommanderAsBackground,
           let artworkURL = player.commanderArtworkURL ?? player.commanderImageURL {
          AsyncImage(url: URL(string: artworkURL)) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
                .opacity(0.4) // Subtle background
                .blur(radius: 1) // Slight blur for text readability
                .rotationEffect(orientation.toAngle())
            case .failure(_):
              Color.clear
            case .empty:
              Color.clear
            @unknown default:
              Color.clear
            }
          }
          .frame(width: geometry.size.width, height: geometry.size.height)
          .cornerRadius(16)
        }
        
        // Player interaction areas
        HStack(spacing: 1) {
          PressableRectangle(
            isPressed: $isLeftPressed,
            player: $player,
            side: .left,
            updatePoints: updatePoints,
            startHoldTimer: startHoldTimer,
            stopHoldTimer: stopHoldTimer
          )

          PressableRectangle(
            isPressed: $isRightPressed,
            player: $player,
            side: .right,
            updatePoints: updatePoints,
            startHoldTimer: startHoldTimer,
            stopHoldTimer: stopHoldTimer
          )
        }
        .cornerRadius(16)
        .overlay(
          RoundedRectangle(cornerRadius: 16)
            .stroke(Color.white.opacity(0.4), lineWidth: 3)
        )
        .foregroundColor(.white)
        .overlay(horizontalPlayerOverlay(geometry: geometry))
        // Apply rotation based on orientation
        .rotationEffect(orientation.toAngle())
        .clipped()
        // Add single-finger swipe gesture using DragGesture with minimumDistance
        .gesture(
          DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded { value in
              // Single-finger swipe gesture for commander damage
              print("🎯 HorizontalPlayerView: Swipe gesture detected")
              
              // For now, let's try a different approach to detect commander gesture area
                _ = value.startLocation
                _ = CGVector(dx: value.translation.width, dy: value.translation.height)
                let distance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
              
              // Only trigger if the drag is significant and in the right area
              if distance > 50 {
                print("✅ HorizontalPlayerView: Potential commander gesture")
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                  showCommanderDamageOverlay = true
                }
              }
            }
        )

        // Player tools overlay
        if showOverlay {
          PlayerToolsOverlay(onDismiss: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              showOverlay = false
            }
          })
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        
        // Commander damage overlay
        if showCommanderDamageOverlay {
          CommanderDamageOverlay(
            player: $player,
            allPlayers: allPlayers,
            onDismiss: {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                showCommanderDamageOverlay = false
              }
            }
          )
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .sheet(isPresented: $showEditSheet) {
        EditPlayerView(player: $player, playerOrientation: orientation)
      }
    }
  }

  // MARK: - Helper Views
  @ViewBuilder
  private func horizontalPlayerOverlay(geometry: GeometryProxy) -> some View {
    ZStack {
      // Calculate name position once for the entire overlay
      let namePosition = getPlayerNamePosition(for: orientation)
      
      // Main HP display - should be readable for each player
      Text("\(player.HP)")
        .font(.system(size: 48, weight: .bold))
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 0)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 0)
        .rotationEffect(namePosition.rotation)

      horizontalIconsOverlay(namePosition: namePosition)
      
      // Change indicator
      if cumulativeChange != 0 {
        Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(cumulativeChange > 0 ? .green : .red)
          .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 0)
          .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 0)
          .offset(x: cumulativeChange > 0 ? 60 : -60)
          .opacity(showChange ? 1 : 0)
          .rotationEffect(namePosition.rotation)
          .animation(.easeInOut(duration: 0.3), value: showChange)
      }

      horizontalPlayerNameView(geometry: geometry, namePosition: namePosition)
      
      // Commander damage and poison counter indicators
      CommanderDamageIndicators(player: player, allPlayers: allPlayers, geometry: geometry, namePosition: namePosition)
      
      // Damage summary badge for quick overview
      DamageSummaryBadge(player: player, allPlayers: allPlayers, namePosition: namePosition)
    }
  }

  @ViewBuilder
  private func horizontalIconsOverlay(namePosition: PlayerNamePosition) -> some View {
    // Minus icon (left side)
    VStack {
      Spacer()
      HStack {
        Image(systemName: "minus")
          .foregroundColor(DEFAULT_STYLES.foreground)
          .font(.system(size: 24, weight: .medium))
          .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 0)
          .rotationEffect(namePosition.rotation)
          .padding(.leading, 32)
        Spacer()
      }
      Spacer()
    }
    
    // Plus icon (right side)
    VStack {
      Spacer()
      HStack {
        Spacer()
        Image(systemName: "plus")
          .foregroundColor(DEFAULT_STYLES.foreground)
          .font(.system(size: 24, weight: .medium))
          .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 0)
          .rotationEffect(namePosition.rotation)
          .padding(.trailing, 32)
      }
      Spacer()
    }
  }

  @ViewBuilder
  private func horizontalPlayerNameView(geometry: GeometryProxy, namePosition: PlayerNamePosition) -> some View {
    // Player name - positioned on the "inner" side so each player can read it normally
    VStack {
      if namePosition.isTop {
        HStack {
          Spacer()
          horizontalPlayerNameText(geometry: geometry, namePosition: namePosition)
            .padding(.top, 12)
          Spacer()
        }
        Spacer()
      } else {
        Spacer()
        HStack {
          Spacer()
          horizontalPlayerNameText(geometry: geometry, namePosition: namePosition)
            .padding(.bottom, 12)
          Spacer()
        }
      }
    }
  }

  @ViewBuilder
  private func horizontalPlayerNameText(geometry: GeometryProxy, namePosition: PlayerNamePosition) -> some View {
    Text(player.name)
      .font(.system(
        size: min(max(geometry.size.width * 0.05, 14), 20), 
        weight: .semibold, 
        design: .rounded
      ))
      .foregroundColor(.white)
      .padding(.horizontal, 12)
      .padding(.vertical, 6)
      .background(
        RoundedRectangle(cornerRadius: 8)
          .fill(Color.black.opacity(0.25))
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.white.opacity(0.15), lineWidth: 1)
          )
      )
      .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
      .rotationEffect(namePosition.rotation)
      .scaleEffect(showEditSheet ? 1.05 : 1.0)
      .animation(.spring(response: 0.3, dampingFraction: 0.6), value: showEditSheet)
      .onTapGesture {
        withAnimation {
          showEditSheet.toggle()
        }
      }
  }
}

// MARK: - Commander Damage Indicators
struct CommanderDamageIndicators: View {
  let player: Player
  let allPlayers: [Player]
  let geometry: GeometryProxy
  let namePosition: PlayerNamePosition
  
  // Get commander damage info with player details - with defensive checks
  private var activeCommanderDamage: [(Player, Int)] {
    var result: [(Player, Int)] = []
    
    // Defensive check: ensure allPlayers array is not empty
    guard !allPlayers.isEmpty else {
      return result
    }
    
    for (opponentId, damage) in player.commanderDamage {
      if damage > 0,
         let opponent = allPlayers.first(where: { $0.id.uuidString == opponentId }) {
        result.append((opponent, damage))
      }
    }
    
    return result.sorted { $0.1 > $1.1 } // Sort by damage descending
  }
  
  // Check if we should show indicators
  private var shouldShow: Bool {
    !activeCommanderDamage.isEmpty || player.poisonCounters > 0
  }
  
  var body: some View {
    if shouldShow {
      VStack {
        if namePosition.isTop {
          Spacer()
          indicatorView
            .padding(.bottom, 8)
        } else {
          indicatorView
            .padding(.top, 8)
          Spacer()
        }
      }
    }
  }
  
  private var indicatorView: some View {
    VStack(spacing: 3) {
      // Commander damage indicators - clearly show each source
      if !activeCommanderDamage.isEmpty {
        VStack(spacing: 2) {
          ForEach(Array(activeCommanderDamage.enumerated()), id: \.offset) { index, damageInfo in
            let (opponent, damage) = damageInfo
            enhancedCommanderDamageIndicator(opponent: opponent, damage: damage)
          }
        }
      }
      
      // Poison counter indicator (if any)
      if player.poisonCounters > 0 {
        enhancedPoisonIndicator
      }
    }
    .rotationEffect(namePosition.rotation)
  }
  
  // Enhanced commander damage indicator - shows source and damage clearly
  private func enhancedCommanderDamageIndicator(opponent: Player, damage: Int) -> some View {
    HStack(spacing: 4) {
      // Commander avatar/icon
      Group {
        if let imageURL = opponent.commanderImageURL,
           let url = URL(string: imageURL) {
          AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .overlay(
                  Circle()
                    .stroke(damage >= 21 ? Color.red : Color.orange, lineWidth: 1.5)
                )
            case .failure(_), .empty:
              enhancedCommanderIcon(damage: damage)
            @unknown default:
              enhancedCommanderIcon(damage: damage)
            }
          }
        } else {
          enhancedCommanderIcon(damage: damage)
        }
      }
      
      // Player initial or short name
      Text(String(opponent.name.prefix(3)).uppercased())
        .font(.system(size: 9, weight: .black, design: .rounded))
        .foregroundColor(.white)
        .frame(minWidth: 14)
      
      // Damage amount with clear visual hierarchy
      Text("\(damage)")
        .font(.system(size: 12, weight: .black, design: .rounded))
        .foregroundColor(damage >= 21 ? .red : .white)
        .frame(minWidth: 16)
    }
    .padding(.horizontal, 6)
    .padding(.vertical, 3)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(
          damage >= 21 
            ? LinearGradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            : LinearGradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              damage >= 21 ? Color.red : Color.orange.opacity(0.8),
              lineWidth: damage >= 21 ? 2 : 1
            )
        )
    )
    .shadow(
      color: damage >= 21 ? Color.red.opacity(0.6) : Color.black.opacity(0.4),
      radius: damage >= 21 ? 4 : 2,
      x: 0,
      y: 1
    )
    .scaleEffect(damage >= 21 ? 1.05 : 1.0)
    .animation(.easeInOut(duration: 0.2), value: damage >= 21)
  }
  
  private func enhancedCommanderIcon(damage: Int) -> some View {
    Circle()
      .fill(
        damage >= 21 
          ? LinearGradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)], startPoint: .top, endPoint: .bottom)
          : LinearGradient(colors: [Color.orange.opacity(0.9), Color.orange.opacity(0.7)], startPoint: .top, endPoint: .bottom)
      )
      .frame(width: 20, height: 20)
      .overlay(
        Image(systemName: "crown.fill")
          .font(.system(size: 10, weight: .bold))
          .foregroundColor(.white)
      )
      .overlay(
        Circle()
          .stroke(damage >= 21 ? Color.red : Color.orange, lineWidth: 1.5)
      )
  }
  
  private var enhancedPoisonIndicator: some View {
    HStack(spacing: 4) {
      // Poison drop icon
      Image(systemName: player.poisonCounters >= 10 ? "skull.fill" : "drop.fill")
        .font(.system(size: 12, weight: .bold))
        .foregroundColor(.white)
        .frame(width: 16)
      
      // "POISON" label
      Text("PSN")
        .font(.system(size: 9, weight: .black, design: .rounded))
        .foregroundColor(.white)
        .frame(minWidth: 16)
      
      // Counter amount
      Text("\(player.poisonCounters)")
        .font(.system(size: 12, weight: .black, design: .rounded))
        .foregroundColor(player.poisonCounters >= 10 ? .red : .white)
        .frame(minWidth: 16)
    }
    .padding(.horizontal, 6)
    .padding(.vertical, 3)
    .background(
      RoundedRectangle(cornerRadius: 8)
        .fill(
          player.poisonCounters >= 10 
            ? LinearGradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)], startPoint: .top, endPoint: .bottom)
            : LinearGradient(colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)], startPoint: .top, endPoint: .bottom)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(
              player.poisonCounters >= 10 ? Color.red : Color.green,
              lineWidth: player.poisonCounters >= 10 ? 2 : 1
            )
        )
    )
    .shadow(
      color: player.poisonCounters >= 10 ? Color.red.opacity(0.6) : Color.green.opacity(0.4),
      radius: player.poisonCounters >= 10 ? 4 : 2,
      x: 0,
      y: 1
    )
    .scaleEffect(player.poisonCounters >= 10 ? 1.05 : 1.0)
    .animation(.easeInOut(duration: 0.2), value: player.poisonCounters >= 10)
  }
}

// MARK: - Helper Functions
struct PlayerNamePosition {
  let isTop: Bool
  let rotation: Angle
}

func getPlayerNamePosition(for orientation: OrientationLayout) -> PlayerNamePosition {
  switch orientation {
  case .normal:
    // Player at bottom - name should be at top (inner side) with no rotation
    return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
  case .inverted:
    // Player at top - name should be at top (inner side) with no rotation  
    return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
  case .left:
    // Player at right - name should be at bottom (inner side) with no rotation
    return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 0))
  case .right:
    // Player at left - name should be at top (inner side) with no rotation
    return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
  }
}

// MARK: - Swipe Detection Helper Functions
func getSwipeDirection(for orientation: OrientationLayout, translation: CGSize) -> CGVector {
  switch orientation {
  case .normal:
    // Normal orientation: swipe down (positive Y)
    return CGVector(dx: 0, dy: 1)
  case .inverted:
    // Inverted orientation: swipe up (negative Y) 
    return CGVector(dx: 0, dy: -1)
  case .left:
    // Left orientation: swipe right (positive X)
    return CGVector(dx: 1, dy: 0)
  case .right:
    // Right orientation: swipe left (negative X)
    return CGVector(dx: -1, dy: 0)
  }
}

// MARK: - Swipe Gesture Validation

func isValidCommanderSwipe(
  startPoint: CGPoint,
  movement: CGVector,
  distance: CGFloat,
  geometry: GeometryProxy
) -> Bool {
  let minimumDistance: CGFloat = 30
  let nameAreaThreshold: CGFloat = 0.3 // 30% from the name edge
  
  // Check if we have enough distance
  guard distance >= minimumDistance else { return false }
  
  // Get the current orientation to determine swipe direction
  let orientation = UIDevice.current.orientation
  
  // Determine the expected swipe direction based on player orientation
  let expectedDirection = getExpectedSwipeDirection(for: orientation, geometry: geometry)
  
  // Check if the movement is in the correct direction
  let isCorrectDirection = isMovementInCorrectDirection(
    movement: movement,
    expectedDirection: expectedDirection
  )
  
  guard isCorrectDirection else { return false }
  
  // Check if the gesture started in the name area
  let isInNameArea = isStartPointInNameArea(
    startPoint: startPoint,
    orientation: orientation,
    geometry: geometry,
    threshold: nameAreaThreshold
  )
  
  return isInNameArea
}

private func getExpectedSwipeDirection(for orientation: UIDeviceOrientation, geometry: GeometryProxy) -> CGVector {
  switch orientation {
  case .portrait:
    return CGVector(dx: 0, dy: 1) // Swipe down
  case .portraitUpsideDown:
    return CGVector(dx: 0, dy: -1) // Swipe up
  case .landscapeLeft:
    return CGVector(dx: -1, dy: 0) // Swipe left
  case .landscapeRight:
    return CGVector(dx: 1, dy: 0) // Swipe right
  default:
    return CGVector(dx: 0, dy: 1) // Default to down
  }
}

private func isMovementInCorrectDirection(movement: CGVector, expectedDirection: CGVector) -> Bool {
  // Normalize the vectors
  let movementMagnitude = sqrt(movement.dx * movement.dx + movement.dy * movement.dy)
  let expectedMagnitude = sqrt(expectedDirection.dx * expectedDirection.dx + expectedDirection.dy * expectedDirection.dy)
  
  guard movementMagnitude > 0 && expectedMagnitude > 0 else { return false }
  
  let normalizedMovement = CGVector(
    dx: movement.dx / movementMagnitude,
    dy: movement.dy / movementMagnitude
  )
  let normalizedExpected = CGVector(
    dx: expectedDirection.dx / expectedMagnitude,
    dy: expectedDirection.dy / expectedMagnitude
  )
  
  // Calculate dot product to check if movements are in similar direction
  let dotProduct = normalizedMovement.dx * normalizedExpected.dx + normalizedMovement.dy * normalizedExpected.dy
  
  // Should be at least 70% aligned with expected direction
  return dotProduct >= 0.7
}

private func isStartPointInNameArea(
  startPoint: CGPoint,
  orientation: UIDeviceOrientation,
  geometry: GeometryProxy,
  threshold: CGFloat
) -> Bool {
  switch orientation {
  case .portrait:
    // Name is at top, swipe should start in top area
    return startPoint.y < geometry.size.height * threshold
  case .portraitUpsideDown:
    // Name is at bottom, swipe should start in bottom area
    return startPoint.y > geometry.size.height * (1 - threshold)
  case .landscapeLeft:
    // Name is at right, swipe should start in right area
    return startPoint.x > geometry.size.width * (1 - threshold)
  case .landscapeRight:
    // Name is at left, swipe should start in left area
    return startPoint.x < geometry.size.width * threshold
  default:
    // Default to top area
    return startPoint.y < geometry.size.height * threshold
  }
}

// MARK: - Legacy Single-Finger Gesture Support (kept for backward compatibility)

func isValidCommanderDamageSwipe(translation: CGSize, direction: CGVector, startLocation: CGPoint, geometry: GeometryProxy) -> Bool {
  let minimumSwipeDistance: CGFloat = 40 // Reduced for better responsiveness
  let nameAreaThreshold: CGFloat = 0.25 // Expanded area (25% from edges)
  
  // Check if swipe started in the name area (more forgiving detection)
  let isInNameArea: Bool
  if direction.dy != 0 {
    // Vertical swipe - check if started in top/bottom area
    if direction.dy > 0 {
      // Swipe down - should start in top area
      isInNameArea = startLocation.y < geometry.size.height * nameAreaThreshold
    } else {
      // Swipe up - should start in bottom area  
      isInNameArea = startLocation.y > geometry.size.height * (1 - nameAreaThreshold)
    }
  } else {
    // Horizontal swipe - check if started in appropriate side area
    if direction.dx > 0 {
      // Swipe right - should start in left area
      isInNameArea = startLocation.x < geometry.size.width * nameAreaThreshold
    } else {
      // Swipe left - should start in right area
      isInNameArea = startLocation.x > geometry.size.width * (1 - nameAreaThreshold)
    }
  }
  
  // Check swipe distance in the correct direction
  let swipeDistance: CGFloat
  if direction.dy != 0 {
    swipeDistance = abs(translation.height * CGFloat(direction.dy))
  } else {
    swipeDistance = abs(translation.width * CGFloat(direction.dx))
  }
  
  // Also check that the swipe is reasonably straight (not too diagonal)
  let straightnessRatio: CGFloat
  if direction.dy != 0 {
    straightnessRatio = abs(translation.height) / max(abs(translation.width), 1)
  } else {
    straightnessRatio = abs(translation.width) / max(abs(translation.height), 1)
  }
  
  return isInNameArea && swipeDistance >= minimumSwipeDistance && straightnessRatio > 1.5
}

// MARK: - Damage Summary Badge
struct DamageSummaryBadge: View {
  let player: Player
  let allPlayers: [Player]
  let namePosition: PlayerNamePosition
  
  // Calculate total commander damage
  private var totalCommanderDamage: Int {
    player.commanderDamage.values.reduce(0, +)
  }
  
  // Check if player is in danger
  private var isDangerous: Bool {
    let hasLethalDamage = player.commanderDamage.values.contains { $0 >= 21 }
    let hasLethalPoison = player.poisonCounters >= 10
    return hasLethalDamage || hasLethalPoison
  }
  
  // Check if should show badge
  private var shouldShow: Bool {
    totalCommanderDamage > 0 || player.poisonCounters > 0
  }
  
  var body: some View {
    if shouldShow {
      VStack {
        if namePosition.isTop {
          badgeView
            .padding(.top, 8)
          Spacer()
        } else {
          Spacer()
          badgeView
            .padding(.bottom, 8)
        }
      }
    }
  }
  
  private var badgeView: some View {
    HStack(spacing: 6) {
      // Warning icon for dangerous states
      if isDangerous {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.system(size: 12, weight: .bold))
          .foregroundColor(.red)
      }
      
      // Damage summary text
      // VStack(spacing: 0) {
      //   if totalCommanderDamage > 0 {
      //     HStack(spacing: 2) {
      //       Text("CMD")
      //         .font(.system(size: 8, weight: .bold))
      //         .foregroundColor(.white.opacity(0.8))
      //       Text("\(totalCommanderDamage)")
      //         .font(.system(size: 10, weight: .black))
      //         .foregroundColor(isDangerous ? .red : .white)
      //     }
      //   }
        
      //   if player.poisonCounters > 0 {
      //     HStack(spacing: 2) {
      //       Text("PSN")
      //         .font(.system(size: 8, weight: .bold))
      //         .foregroundColor(.white.opacity(0.8))
      //       Text("\(player.poisonCounters)")
      //         .font(.system(size: 10, weight: .black))
      //         .foregroundColor(player.poisonCounters >= 10 ? .red : .white)
      //     }
      //   }
      // }
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 4)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(
          isDangerous 
            ? LinearGradient(colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)], startPoint: .top, endPoint: .bottom)
            : LinearGradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)], startPoint: .top, endPoint: .bottom)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 6)
            .stroke(
              isDangerous ? Color.red : Color.white.opacity(0.3),
              lineWidth: isDangerous ? 1.5 : 1
            )
        )
    )
    .rotationEffect(namePosition.rotation)
    .shadow(
      color: isDangerous ? Color.red.opacity(0.4) : Color.black.opacity(0.3),
      radius: isDangerous ? 3 : 2,
      x: 0,
      y: 1
    )
    .scaleEffect(isDangerous ? 1.1 : 1.0)
    .animation(.easeInOut(duration: 0.2), value: isDangerous)
  }
}

// MARK: - Preview
#Preview("Horizontal Player View") {
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
    .background(Color.black)
}
