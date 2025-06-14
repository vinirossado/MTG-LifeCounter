//
//  HorizontalPlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI
import UIKit


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
                // Fundo da view do jogador
                HStack(spacing: 0) {
                    // Lado esquerdo do fundo (apenas visual)
                    Rectangle()
                        .fill(DEFAULT_STYLES.background)
                        .opacity(isLeftPressed ? DEFAULT_STYLES.hoverOpacity * 0.8 : DEFAULT_STYLES.opacity)
                        .overlay(
                            Rectangle()
                                .stroke(Color.white.opacity(isLeftPressed ? 0.3 : 0), lineWidth: 2)
                        )
                        .scaleEffect(isLeftPressed ? 0.98 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isLeftPressed)
                        .zIndex(10)
                    
                    // Lado direito do fundo (apenas visual)
                    Rectangle()
                        .fill(Color(.red))
                        .opacity(isRightPressed ? DEFAULT_STYLES.hoverOpacity * 0.8 : DEFAULT_STYLES.opacity)
                        .overlay(
                            Rectangle()
                                .stroke(Color.white.opacity(isRightPressed ? 0.3 : 0), lineWidth: 2)
                        )
                        .scaleEffect(isRightPressed ? 0.98 : 1.0)
                        .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isRightPressed)
                }
                .cornerRadius(16)
                .foregroundColor(.white)
                .overlay(
                    GeometryReader { overlayGeometry in
                        ZStack {
                            // Player life total (centered)
                            Text("\(player.HP)")
                                .font(.system(size: 48))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            // Touch target areas that properly align with visual indicators
                            HStack(spacing: 0) {
                                // Left half - Decrease area
                                Button(action: {
                                    print(">>> LEFT AREA PRESSED - Decrease\n")
                                    
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
                                    
                                    updatePoints(.left, 1)
                                }) {
                                    HStack {
                                        // Left side minus indicator
                                        Image(systemName: "minus")
                                            .foregroundColor(DEFAULT_STYLES.foreground)
                                            .font(.system(size: 24))
                                            .padding(12)
                                            .background(Circle().fill(Color.white.opacity(0.1)))
                                        Spacer()
                                    }
                                    .padding(.leading, 32)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: overlayGeometry.size.width / 2)
                                .contentShape(Rectangle())
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.3)
                                        .onChanged { value in
                                            withAnimation {
                                                isLeftPressed = true
                                            }
                                            print(">>> LEFT LONG PRESS STARTED\n")
                                            let generator = UIImpactFeedbackGenerator(style: .medium)
                                            generator.impactOccurred()
                                            startHoldTimer(.left, 5)
                                        }
                                        .onEnded { _ in
                                            withAnimation {
                                                isLeftPressed = false
                                            }
                                            print(">>> LEFT LONG PRESS ENDED\n")
                                            stopHoldTimer()
                                        }
                                )
                                
                                // Right half - Increase area
                                Button(action: {
                                    print(">>> RIGHT AREA PRESSED - Increase\n")
                                    
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
                                    
                                    // Update the points
                                    updatePoints(.right, 1)
                                }) {
                                    HStack {
                                        Spacer()
                                        // Right side plus indicator
                                        Image(systemName: "plus")
                                            .foregroundColor(DEFAULT_STYLES.foreground)
                                            .font(.system(size: 24))
                                            .padding(12)
                                            .background(Circle().fill(Color.white.opacity(0.1)))
                                    }
                                    .padding(.trailing, 32)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .frame(width: overlayGeometry.size.width / 2)
                                .contentShape(Rectangle())
                                .simultaneousGesture(
                                    LongPressGesture(minimumDuration: 0.3)
                                        .onChanged { value in
                                            withAnimation {
                                                isRightPressed = true
                                            }
                                            print(">>> RIGHT LONG PRESS STARTED\n")
                                            let generator = UIImpactFeedbackGenerator(style: .medium)
                                            generator.impactOccurred()
                                            startHoldTimer(.right, 5)
                                        }
                                        .onEnded { _ in
                                            withAnimation {
                                                isRightPressed = false
                                            }
                                            print(">>> RIGHT LONG PRESS ENDED\n")
                                            stopHoldTimer()
                                        }
                                )
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                            if cumulativeChange != 0 {
                                Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                                    .font(.system(size: 24))
                                    .foregroundColor(DEFAULT_STYLES.foreground)
                                    .offset(x: cumulativeChange > 0 ? 60 : -60)
                                    .opacity(showChange ? 1 : 0)
                                    .animation(.easeInOut(duration: 0.3), value: showChange)
                            }
                            
                            VStack {
                                Text(player.name)
                                    .font(.system(size: 24))
                                    .foregroundColor(DEFAULT_STYLES.foreground)
                                    .onTapGesture {
                                        showEditSheet = true
                                    }
                                Spacer()
                            }
                            .padding(.top, 12)
                            
                            // Two-finger gesture recognizer indicator (visual hint)
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image(systemName: "hand.draw.fill")
                                        .font(.system(size: 20))
                                        .opacity(0.5)
                                        .foregroundColor(DEFAULT_STYLES.foreground)
                                        .padding(8)
                                }
                                .padding(.trailing, 12)
                                .padding(.bottom, 12)
                            }
                        }
                    })
                .rotationEffect((orientation.toAngle()))
                .twoFingerSwipe(direction: .up, perform: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showOverlay = true
                    }
                })
                
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

