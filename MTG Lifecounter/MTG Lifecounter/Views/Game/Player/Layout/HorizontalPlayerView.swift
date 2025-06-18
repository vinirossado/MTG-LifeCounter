//
//  HorizontalPlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI
import UIKit

struct PressableRectangle: View {
  @Binding var isPressed: Bool
  @Binding var player: Player
  var side: SideEnum
  var updatePoints: (SideEnum, Int) -> Void
  var startHoldTimer: (SideEnum, Int) -> Void
  var stopHoldTimer: () -> Void

  var body: some View {
    Rectangle()
      .fill(side == .left ? DEFAULT_STYLES.background : Color.red.opacity(0.8))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .opacity(isPressed ? DEFAULT_STYLES.hoverOpacity : DEFAULT_STYLES.opacity)
      .overlay(
        Rectangle()
          .stroke(Color.white.opacity(0.2), lineWidth: 1.5)
      )
      .overlay(
        Rectangle()
          .stroke(
            LinearGradient(
              colors: [
                Color.white.opacity(isPressed ? 0.8 : 0),
                Color.blue.opacity(isPressed ? 0.6 : 0)
              ],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            ),
            lineWidth: isPressed ? 3 : 0
          )
          .scaleEffect(isPressed ? 0.96 : 1.0)
          .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isPressed)
      )
      .scaleEffect(isPressed ? 0.98 : 1.0)
      .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isPressed)
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
  let updatePoints: UpdatePointsFunc
  let startHoldTimer: TimerHandlerFunc
  let stopHoldTimer: StopTimerFunc
  var orientation: OrientationLayout
  @State private var showEditSheet = false
  @State private var showOverlay = false
  @State private var dragDistance: CGFloat = 0
  @State private var overlayOpacity: Double = 0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
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
        .overlay(
          ZStack {
            // Calculate name position once for the entire overlay
            let namePosition = getPlayerNamePosition(for: orientation)
            
            // Main HP display - should be readable for each player
            Text("\(player.HP)")
              .font(.system(size: 48, weight: .bold))
              .foregroundColor(.white)
              .rotationEffect(namePosition.rotation)

            // Minus icon (left side)
            VStack {
              Spacer()
              HStack {
                Image(systemName: "minus")
                  .foregroundColor(DEFAULT_STYLES.foreground)
                  .font(.system(size: 24, weight: .medium))
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
                  .rotationEffect(namePosition.rotation)
                  .padding(.trailing, 32)
              }
              Spacer()
            }

            // Change indicator
            if cumulativeChange != 0 {
              Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(cumulativeChange > 0 ? .green : .red)
                .offset(x: cumulativeChange > 0 ? 60 : -60)
                .opacity(showChange ? 1 : 0)
                .rotationEffect(namePosition.rotation)
                .animation(.easeInOut(duration: 0.3), value: showChange)
            }

            // Player name - positioned on the "inner" side so each player can read it normally
            
            VStack {
              if namePosition.isTop {
                HStack {
                  Spacer()
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
                    .padding(.top, 12)
                  Spacer()
                }
                Spacer()
              } else {
                Spacer()
                HStack {
                  Spacer()
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
                    .padding(.bottom, 12)
                  Spacer()
                }
              }
            }
          }
        )
        // Apply rotation based on orientation
        .rotationEffect(orientation.toAngle())
        .clipped()

        // Player tools overlay
        if showOverlay {
          PlayerToolsOverlay(onDismiss: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              showOverlay = false
            }
          })
          .transition(.move(edge: .bottom).combined(with: .opacity))
        }
      }
      .sheet(isPresented: $showEditSheet) {
        EditPlayerView(player: $player)
      }
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
        updatePoints: { _, _ in },
        startHoldTimer: { _, _ in },
        stopHoldTimer: { },
        orientation: .normal
    )
    .frame(width: 300, height: 200)
    .background(Color.black)
}
