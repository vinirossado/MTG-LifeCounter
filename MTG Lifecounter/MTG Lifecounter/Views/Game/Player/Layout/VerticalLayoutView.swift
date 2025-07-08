//
//  VerticalLayoutView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

// Import necessary types and utilities
// These are defined in the same module so no explicit import needed,
// but we need to ensure the types are accessible

struct VerticalPressableRectangle: View {
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
        updatePoints(side, 1)
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

// MARK: - Helper Functions for Vertical Layout
func getVerticalPlayerNamePosition(for orientation: OrientationLayout) -> PlayerNamePosition {
  switch orientation {
  case .left:
    // Player at right - name should be at left (inner side) with no rotation
    return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
  case .right:
    // Player at left - name should be at right (inner side) with no rotation
    return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 0))
  default:
    // Fallback for other orientations
    return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
  }
}

// MARK: - Vertical Player View
struct VerticalPlayerView: View {
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
        
        // Player interaction areas (left and right sides for decrease/increase)
        HStack(spacing: 1) {
          VerticalPressableRectangle(
            isPressed: $isLeftPressed,
            player: $player,
            side: .left,
            updatePoints: updatePoints,
            startHoldTimer: startHoldTimer,
            stopHoldTimer: stopHoldTimer
          )

          VerticalPressableRectangle(
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
        .overlay(verticalPlayerOverlay(geometry: geometry))
        // Apply rotation based on orientation
        .rotationEffect(orientation.toAngle())
        .clipped()
        // Add single-finger swipe gesture using DragGesture with minimumDistance  
        .gesture(
          DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded { value in
              // Single-finger swipe gesture for commander damage
              print("🎯 VerticalLayoutView: Swipe gesture detected")
              
              // For now, let's try a different approach to detect commander gesture area
                _ = value.startLocation
                _ = CGVector(dx: value.translation.width, dy: value.translation.height)
                let distance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
              
              // Only trigger if the drag is significant and in the right area
              if distance > 50 {
                print("✅ VerticalLayoutView: Potential commander gesture")
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
            playerOrientation: orientation, // Add orientation parameter
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
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }

  // MARK: - Helper Views
  @ViewBuilder
  private func verticalPlayerOverlay(geometry: GeometryProxy) -> some View {
    ZStack {
      // Calculate name position once for the entire overlay
      let namePosition = getVerticalPlayerNamePosition(for: orientation)
      
      // Main HP display - should be readable for each player
      Text("\(player.HP)")
        .font(.system(size: 48, weight: .bold))
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 0)
        .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 0)
        .rotationEffect(namePosition.rotation)

      verticalIconsOverlay(namePosition: namePosition)
      
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

      verticalPlayerNameView(geometry: geometry, namePosition: namePosition)
      
      // Commander damage and poison counter indicators
      CommanderDamageIndicators(player: player, allPlayers: allPlayers, geometry: geometry, namePosition: namePosition)
      
      // Damage summary badge for quick overview  
      DamageSummaryBadge(player: player, allPlayers: allPlayers, namePosition: namePosition)
    }
  }

  @ViewBuilder
  private func verticalIconsOverlay(namePosition: PlayerNamePosition) -> some View {
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
  private func verticalPlayerNameView(geometry: GeometryProxy, namePosition: PlayerNamePosition) -> some View {
    // Player name - positioned on the "inner" side so each player can read it normally
    if namePosition.isTop {
      VStack {
        HStack {
          Spacer()
          playerNameText(geometry: geometry, namePosition: namePosition)
            .padding(.top, 12)
          Spacer()
        }
        Spacer()
      }
    } else {
      VStack {
        Spacer()
        HStack {
          Spacer()
          playerNameText(geometry: geometry, namePosition: namePosition)
            .padding(.bottom, 12)
          Spacer()
        }
      }
    }
  }

  @ViewBuilder
  private func playerNameText(geometry: GeometryProxy, namePosition: PlayerNamePosition) -> some View {
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

// MARK: - Swipe Detection Helper Functions for Vertical Layout
func getSwipeDirectionVertical(for orientation: OrientationLayout, translation: CGSize) -> CGVector {
  switch orientation {
  case .left:
    // Left orientation: swipe down (positive Y) in the rotated view
    return CGVector(dx: 0, dy: 1)
  case .right:
    // Right orientation: swipe up (negative Y) in the rotated view
    return CGVector(dx: 0, dy: -1)
  default:
    // Fallback - should not happen in vertical layout
    return CGVector(dx: 0, dy: 1)
  }
}

// MARK: - Swipe Gesture Validation

func isValidCommanderSwipeVertical(
  startPoint: CGPoint,
  movement: CGVector,
  distance: CGFloat,
  geometry: GeometryProxy
) -> Bool {
  let minimumDistance: CGFloat = 30
  let nameAreaThreshold: CGFloat = 0.3 // 30% from the name edge
  
  // Check if we have enough distance
  guard distance >= minimumDistance else { return false }
  
  // For vertical layout, we always expect vertical swipes (up or down)
  // Check if the movement is primarily vertical
  let isVerticalMovement = abs(movement.dy) > abs(movement.dx) * 1.5 // 1.5x more vertical than horizontal
  guard isVerticalMovement else { return false }
  
  // Check if the gesture started in the name area
  // For vertical layout, name can be at top or bottom depending on orientation
  let isInNameArea: Bool
  if movement.dy > 0 {
    // Swipe down - should start in top area (where name usually is)
    isInNameArea = startPoint.y < geometry.size.height * nameAreaThreshold
  } else {
    // Swipe up - should start in bottom area
    isInNameArea = startPoint.y > geometry.size.height * (1 - nameAreaThreshold)
  }
  
  return isInNameArea
}

// MARK: - Legacy Single-Finger Gesture Support (kept for backward compatibility)

func isValidCommanderDamageSwipeVertical(translation: CGSize, direction: CGVector, startLocation: CGPoint, geometry: GeometryProxy) -> Bool {
  let minimumSwipeDistance: CGFloat = 50
  let nameAreaThreshold: CGFloat = 0.3 // Top/bottom 30% depending on orientation
  
  // Check if swipe started in the name area
  let isInNameArea: Bool
  if direction.dy > 0 {
    // Swipe down - should start in top area (where name is positioned)
    isInNameArea = startLocation.y < geometry.size.height * nameAreaThreshold
  } else {
    // Swipe up - should start in bottom area (where name is positioned)
    isInNameArea = startLocation.y > geometry.size.height * (1 - nameAreaThreshold)
  }
  
  // Check swipe distance in the correct direction
  let swipeDistance = abs(translation.height * CGFloat(direction.dy))
  
  return isInNameArea && swipeDistance >= minimumSwipeDistance
}

// MARK: - Preview
#Preview("Vertical Player View") {
    VerticalPlayerView(
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
        orientation: .left
    )
    .frame(width: 200, height: 300)
    .background(Color.black)
}
