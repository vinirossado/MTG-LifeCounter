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
  @State private var showCommanderDamageOverlay = false // Add this state
  @State private var dragDistance: CGFloat = 0
  @State private var overlayOpacity: Double = 0

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
        // Add two-finger swipe gesture for commander damage
        .gesture(
          DragGesture(minimumDistance: 30)
            .onChanged { value in
              // Detect if this is a two-finger gesture (we'll simulate with single finger for testing)
              let swipeDirection = getSwipeDirection(for: orientation, translation: value.translation)
              if isValidCommanderDamageSwipe(translation: value.translation, direction: swipeDirection, startLocation: value.startLocation, geometry: geometry) {
                  dragDistance = value.translation.height  
              }
            }
            .onEnded { value in
              let swipeDirection = getSwipeDirection(for: orientation, translation: value.translation)
              if isValidCommanderDamageSwipe(translation: value.translation, direction: swipeDirection, startLocation: value.startLocation, geometry: geometry) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                  showCommanderDamageOverlay = true
                }
              }
              dragDistance = 0
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
      CommanderDamageIndicators(player: player, geometry: geometry, namePosition: namePosition)
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
  let geometry: GeometryProxy
  let namePosition: PlayerNamePosition
  
  // Calculate total commander damage
  private var totalCommanderDamage: Int {
    player.commanderDamage.values.reduce(0, +)
  }
  
  // Check if we should show indicators
  private var shouldShow: Bool {
    totalCommanderDamage > 0 || player.poisonCounters > 0
  }
  
  var body: some View {
    if shouldShow {
      VStack {
        if namePosition.isTop {
          Spacer()
          indicatorView
            .padding(.bottom, 12)
        } else {
          indicatorView
            .padding(.top, 12)
          Spacer()
        }
      }
    }
  }
  
  private var indicatorView: some View {
    HStack(spacing: 8) {
      Spacer()
      
      // Commander damage indicator
      if totalCommanderDamage > 0 {
        HStack(spacing: 4) {
          Image(systemName: "crown.fill")
            .font(.caption)
            .foregroundColor(.orange)
          
          Text("\(totalCommanderDamage)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .fill(Color.black.opacity(0.6))
            .overlay(
              RoundedRectangle(cornerRadius: 6)
                .stroke(Color.orange.opacity(0.6), lineWidth: 1)
            )
        )
        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
        .rotationEffect(namePosition.rotation)
      }
      
      // Poison counter indicator
      if player.poisonCounters > 0 {
        HStack(spacing: 4) {
          Image(systemName: "drop.fill")
            .font(.caption)
            .foregroundColor(player.poisonCounters >= 10 ? .red : .green)
          
          Text("\(player.poisonCounters)")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(player.poisonCounters >= 10 ? .red : .white)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
          RoundedRectangle(cornerRadius: 6)
            .fill(player.poisonCounters >= 10 ? Color.red.opacity(0.3) : Color.black.opacity(0.6))
            .overlay(
              RoundedRectangle(cornerRadius: 6)
                .stroke(
                  player.poisonCounters >= 10 ? Color.red.opacity(0.8) : Color.green.opacity(0.6), 
                  lineWidth: 1
                )
            )
        )
        .shadow(
          color: player.poisonCounters >= 10 ? Color.red.opacity(0.5) : Color.black.opacity(0.3), 
          radius: player.poisonCounters >= 10 ? 4 : 2, 
          x: 0, 
          y: 1
        )
        .rotationEffect(namePosition.rotation)
      }
      
      Spacer()
    }
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

func isValidCommanderDamageSwipe(translation: CGSize, direction: CGVector, startLocation: CGPoint, geometry: GeometryProxy) -> Bool {
  let minimumSwipeDistance: CGFloat = 50
  let nameAreaThreshold: CGFloat = 0.3 // Top 30% or bottom 30% depending on orientation
  
  // Check if swipe started in the name area
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
  
  return isInNameArea && swipeDistance >= minimumSwipeDistance
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
