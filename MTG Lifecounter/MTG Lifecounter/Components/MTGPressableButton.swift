//
//  MTGPressableButton.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 8.07.2025.
//

import SwiftUI

/// A reusable MTG-themed pressable button component that provides tactile feedback
/// and magical visual effects for life counter interactions
struct MTGPressableButton: View {
    // MARK: - Properties
    @Binding var isPressed: Bool
    let side: SideEnum
    let onTap: () -> Void
    let onLongPress: (Bool) -> Void
    
    @State private var subtlePulse: Double = 0.1
    
    // MARK: - Computed Properties
    private var rectangleGradient: LinearGradient {
        let baseColors = side == .left 
            ? [Color.MTG.arcaneBlue.opacity(0.6), Color.MTG.deepBlack.opacity(0.7)]
            : [Color.MTG.arcaneBlue.opacity(0.6), Color.MTG.deepBlack.opacity(0.5)]
        
        return LinearGradient(
            colors: baseColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var borderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.MTG.textPrimary.opacity(0.15),
                Color.MTG.blue.opacity(0.1),
                Color.MTG.textPrimary.opacity(0.15)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var pressedGlowGradient: LinearGradient {
        LinearGradient(
            colors: isPressed 
                ? (side == .left 
                    ? [Color.MTG.blue.opacity(0.8), Color.MTG.glowSecondary.opacity(0.6)]
                    : [Color.MTG.red.opacity(0.9), Color.MTG.gold.opacity(0.7)])
                : [Color.clear, Color.clear],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var cornerDecorationColors: [Color] {
        side == .left 
            ? [Color.MTG.blue.opacity(0.3), Color.MTG.glowSecondary.opacity(0.2)]
            : [Color.MTG.red.opacity(0.3), Color.MTG.gold.opacity(0.2)]
    }
    
    private var shadowColor: Color {
        side == .left ? Color.MTG.blue.opacity(subtlePulse) : Color.MTG.red.opacity(subtlePulse)
    }
    
    // MARK: - Body
    var body: some View {
        Rectangle()
            .fill(rectangleGradient)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isPressed ? 0.75 : 1.0)
            .overlay(borderOverlay)
            .overlay(pressedGlowOverlay)
            .overlay(cornerDecorations)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(MTGAnimation.gentleSpring, value: isPressed)
            .onAppear(perform: startSubtlePulse)
            .onTapGesture(perform: handleTap)
            .onLongPressGesture(
                minimumDuration: 0.2,
                maximumDistance: 0.4,
                pressing: handleLongPress,
                perform: {}
            )
    }
    
    // MARK: - View Builders
    private var borderOverlay: some View {
        Rectangle()
            .stroke(borderGradient, lineWidth: MTGSpacing.borderWidth)
    }
    
    private var pressedGlowOverlay: some View {
        Rectangle()
            .stroke(pressedGlowGradient, lineWidth: isPressed ? 3 : 0)
            .scaleEffect(isPressed ? 0.96 : 1.0)
            .animation(MTGAnimation.standardSpring, value: isPressed)
    }
    
    private var cornerDecorations: some View {
        VStack {
            HStack {
                cornerDecoration
                Spacer()
                cornerDecoration
            }
            Spacer()
            HStack {
                cornerDecoration
                Spacer()
                cornerDecoration
            }
        }
        .padding(MTGSpacing.sm * 1.5)
    }
    
    private var cornerDecoration: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: cornerDecorationColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 8, height: 8)
            .opacity(isPressed ? 0.8 : 0.3)
            .shadow(color: shadowColor, radius: 4, x: 0, y: 0)
    }
    
    // MARK: - Actions
    private func startSubtlePulse() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            subtlePulse = 0.3
        }
    }
    
    private func handleTap() {
        withAnimation(MTGAnimation.quick) {
            isPressed = true
        }
        
        onTap()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(MTGAnimation.quick) {
                isPressed = false
            }
        }
    }
    
    private func handleLongPress(_ pressing: Bool) {
        withAnimation(MTGAnimation.standardSpring) {
            isPressed = pressing
        }
        onLongPress(pressing)
    }
}

// MARK: - Preview
#Preview("MTG Pressable Button") {
    HStack(spacing: 2) {
        MTGPressableButton(
            isPressed: .constant(false),
            side: .left,
            onTap: { print("Left tap") },
            onLongPress: { pressing in print("Left long press: \(pressing)") }
        )
        
        MTGPressableButton(
            isPressed: .constant(false),
            side: .right,
            onTap: { print("Right tap") },
            onLongPress: { pressing in print("Right long press: \(pressing)") }
        )
    }
    .frame(height: 200)
    .background(Color.MTG.deepBlack)
}
