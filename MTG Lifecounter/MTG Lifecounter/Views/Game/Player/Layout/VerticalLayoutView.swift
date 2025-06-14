//
//  VerticalLayoutView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI
import UIKit

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
  @State private var showOverlay = false
  @State private var showEditSheet = false
  @State private var dragDistance: CGFloat = 0
  @State private var overlayOpacity: Double = 0

  let updatePoints: UpdatePointsFunc
  let startHoldTimer: TimerHandlerFunc
  let stopHoldTimer: StopTimerFunc
  var orientation: OrientationLayout

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        VStack(spacing: 0) {
          // Área superior - para aumentar (lembre-se que na vertical a lógica é invertida)
          Rectangle()
            .fill(DEFAULT_STYLES.background)
            .opacity(isLeftPressed ? DEFAULT_STYLES.hoverOpacity * 0.8 : DEFAULT_STYLES.opacity)
            .overlay(
              Rectangle()
                .stroke(Color.white.opacity(isLeftPressed ? 0.3 : 0), lineWidth: 2)
            )
            .scaleEffect(isLeftPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isLeftPressed)
            .contentShape(Rectangle())
            .onTapGesture {
              print(">>> TOP AREA TAPPED - Increase\n")
              // Gerar feedback háptico
              let generator = UIImpactFeedbackGenerator(style: .light)
              generator.impactOccurred()

              // Adicionar animação visual ao tocar
              withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                isLeftPressed = true
              }

              // Resetar após breve delay
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                  isLeftPressed = false
                }
              }

              updatePoints(.right, 1)  // Inverte para manter consistência com orientação
            }
            .onLongPressGesture(minimumDuration: 0.3) { pressing in
              withAnimation {
                isLeftPressed = pressing
              }

              if pressing {
                print(">>> TOP LONG PRESS STARTED\n")
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                startHoldTimer(.right, 5)
              } else {
                print(">>> TOP LONG PRESS ENDED\n")
                stopHoldTimer()
              }
            } perform: {
            }

          // Área inferior - para diminuir
          Rectangle()
            .fill(DEFAULT_STYLES.background)
            .opacity(isRightPressed ? DEFAULT_STYLES.hoverOpacity * 0.8 : DEFAULT_STYLES.opacity)
            .overlay(
              Rectangle()
                .stroke(Color.white.opacity(isRightPressed ? 0.3 : 0), lineWidth: 2)
            )
            .scaleEffect(isRightPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isRightPressed)
            .contentShape(Rectangle())
            .onTapGesture {
              print(">>> BOTTOM AREA TAPPED - Decrease\n")
              // Gerar feedback háptico
              let generator = UIImpactFeedbackGenerator(style: .light)
              generator.impactOccurred()

              // Adicionar animação visual ao tocar
              withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                isRightPressed = true
              }

              // Resetar após breve delay
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                  isRightPressed = false
                }
              }

              updatePoints(.left, 1)  // Inverte para manter consistência com orientação
            }
            .onLongPressGesture(minimumDuration: 0.3) { pressing in
              withAnimation {
                isRightPressed = pressing
              }

              if pressing {
                print(">>> BOTTOM LONG PRESS STARTED\n")
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                startHoldTimer(.left, 5)
              } else {
                print(">>> BOTTOM LONG PRESS ENDED\n")
                stopHoldTimer()
              }
            } perform: {
            }
        }.cornerRadius(16)
          .foregroundColor(.white)
          .overlay(
            GeometryReader { overlayGeometry in
              ZStack {
                // Player life total (centered)
                Text("\(player.HP)")
                  .font(.system(size: 48))
                  .rotationEffect(Angle(degrees: 270))
                  .frame(maxWidth: .infinity, maxHeight: .infinity)

             
                  // Top half - Increase area
                  Button(action: {
                    print(">>> TOP AREA PRESSED - Increase\n")

                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()

                    // Visual feedback animation
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                      isLeftPressed = true
                    }

                    // Reset animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                      withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                        isLeftPressed = false
                      }
                    }

                    // Update the points with inverted logic for vertical layout
                    updatePoints(.right, 1)
                  }) {
                    // Full width/height with plus sign on the right side
                    ZStack(alignment: .topTrailing) {
                      Rectangle()
                        .fill(Color.clear)

                      // Plus indicator positioned at top right
                      Image(systemName: "plus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                        .padding(12)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                        .padding(.top, 32)
                        .padding(.trailing, 32)
                    }
                  }
                  .buttonStyle(PlainButtonStyle())
                  .frame(width: overlayGeometry.size.width, height: overlayGeometry.size.height / 2)
                  .contentShape(Rectangle())
                  .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.3)
                      .onChanged { value in
                        withAnimation {
                          isLeftPressed = true
                        }
                        print(">>> TOP LONG PRESS STARTED\n")
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        startHoldTimer(.right, 5)  // Inverted logic for vertical
                      }
                      .onEnded { _ in
                        withAnimation {
                          isLeftPressed = false
                        }
                        print(">>> TOP LONG PRESS ENDED\n")
                        stopHoldTimer()
                      }
                  )

                  // Bottom half - Decrease area
                  Button(action: {
                    print(">>> BOTTOM AREA PRESSED - Decrease\n")

                    // Haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()

                    // Visual feedback animation
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                      isRightPressed = true
                    }

                    // Reset animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                      withAnimation(.spring(response: 0.15, dampingFraction: 0.5)) {
                        isRightPressed = false
                      }
                    }

                    // Update the points with inverted logic for vertical layout
                    updatePoints(.left, 1)
                  }) {
                    // Full width/height with minus sign on the right side
                    ZStack(alignment: .bottomTrailing) {
                      Rectangle()
                        .fill(Color.clear)

                      // Minus indicator positioned at bottom right
                      Image(systemName: "minus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                        .rotationEffect(Angle(degrees: 90))
                        .padding(12)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                        .padding(.bottom, 32)
                        .padding(.trailing, 32)
                    }
                  }
                  .buttonStyle(PlainButtonStyle())
                  .frame(width: overlayGeometry.size.width, height: overlayGeometry.size.height / 2)
                  .contentShape(Rectangle())
                  .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.3)
                      .onChanged { value in
                        withAnimation {
                          isRightPressed = true
                        }
                        print(">>> BOTTOM LONG PRESS STARTED\n")
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                        startHoldTimer(.left, 5)  // Inverted logic for vertical
                      }
                      .onEnded { _ in
                        withAnimation {
                          isRightPressed = false
                        }
                        print(">>> BOTTOM LONG PRESS ENDED\n")
                        stopHoldTimer()
                      }
                  )
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if cumulativeChange != 0 {
                  Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                    .font(.system(size: 24))
                    .foregroundColor(DEFAULT_STYLES.foreground)
                    .offset(x: cumulativeChange > 0 ? 60 : -60)
                    .opacity(showChange ? 1 : 0)
                    .rotationEffect(Angle(degrees: 270))
                }

                HStack {
                  Text(player.name)
                    .font(.system(size: 24))
                    .foregroundColor(DEFAULT_STYLES.foreground)
                    .rotationEffect(Angle(degrees: 270))
                    .onTapGesture {
                      showEditSheet.toggle()
                    }
                  Spacer()
                }

                // Two-finger gesture recognizer indicator (visual hint)
//                VStack {
//                  Spacer()
//                  HStack {
//                    Spacer()
//                    Image(systemName: "hand.draw.fill")
//                      .font(.system(size: 20))
//                      .opacity(0.5)
//                      .foregroundColor(DEFAULT_STYLES.foreground)
//                      .padding(8)
//                  }
//                  .padding(.trailing, 12)
//                  .padding(.bottom, 12)
//                }
              }
            }
          )
          .rotationEffect((orientation.toAngle()))

//          .twoFingerSwipe(
//            direction: .up,
//            perform: {
//              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
//                showOverlay = true
//              }
//            })

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
