//
//  MTGConfirmationDialog.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.06.2025.
//

import SwiftUI

struct MTGConfirmationDialog: View {
    let title: String
    let message: String
    let confirmText: String
    let cancelText: String
    let onConfirm: () -> Void
    let onCancel: () -> Void
    @State private var isVisible = false
    @State private var cardRotation: Double = 0
    
    var body: some View {
        ZStack {
            // Mystical background overlay
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        onCancel()
                    }
                }
            
            // Main card-like dialog
            VStack(spacing: 0) {
                // Card frame with border
                VStack(spacing: 20) {
                    // Mystical header with mana symbols-inspired decoration
                    HStack {
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                        
                        Rectangle()
                            .fill(LinearGradient(
                                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(height: 2)
                        
                        Circle()
                            .fill(LinearGradient(
                                colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.4), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 20)
                    
                    // Title with mystical styling
                    Text(title)
                        .font(.system(size: 26, weight: .bold, design: .serif))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.white, Color.lightGrayText],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    // Message text with scroll-like background
                    VStack(spacing: 12) {
                        Text(message)
                            .font(.system(size: 18, weight: .medium, design: .serif))
                            .foregroundColor(.lightGrayText)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.oceanBlueBackground.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                    )
                    
                    // Action buttons with spell-like styling
                    HStack(spacing: 16) {
                        // Cancel button (defensive/protective magic)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                onCancel()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text(cancelText)
                                    .font(.system(size: 16, weight: .semibold, design: .serif))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.5)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(MTGButtonStyle())
                        
                        // Confirm button (powerful/destructive magic)
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                onConfirm()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Image(systemName: "bolt.fill")
                                    .font(.system(size: 16, weight: .medium))
                                Text(confirmText)
                                    .font(.system(size: 16, weight: .semibold, design: .serif))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.red.opacity(0.8), Color.red.opacity(0.6)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: Color.red.opacity(0.4), radius: 6, x: 0, y: 3)
                        }
                        .buttonStyle(MTGButtonStyle())
                    }
                    .padding(.horizontal, 20)
                }
                .padding(24)
                .background(
                    // Card-like background with mystical border
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.darkNavyBackground,
                                    Color.oceanBlueBackground.opacity(0.9)
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
                                            Color.blue.opacity(0.6),
                                            Color.purple.opacity(0.4),
                                            Color.blue.opacity(0.6)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: Color.blue.opacity(0.3), radius: 20, x: 0, y: 10)
                        .shadow(color: Color.black.opacity(0.5), radius: 40, x: 0, y: 20)
                )
            }
            .frame(maxWidth: 380)
            .padding(.horizontal, 20)
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .rotation3DEffect(
                .degrees(cardRotation),
                axis: (x: 1, y: 0, z: 0)
            )
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isVisible = true
            }
            
            // Subtle card animation
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                cardRotation = 2
            }
        }
    }
}

// MARK: - Preset Configurations
extension MTGConfirmationDialog {
    // Preset for game reset confirmation
    static func gameReset(onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) -> MTGConfirmationDialog {
        MTGConfirmationDialog(
            title: "Reset the Battlefield?",
            message: "This will reset all life totals and start a new game. Your current progress will be lost to the void.",
            confirmText: "Cast",
            cancelText: "Counter",
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
    
    // Preset for dangerous actions
    static func dangerousAction(
        title: String,
        message: String,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) -> MTGConfirmationDialog {
        MTGConfirmationDialog(
            title: title,
            message: message,
            confirmText: "Cast Spell",
            cancelText: "Counter",
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
    
    // Preset for leaving/quitting
    static func leaveBattlefield(onConfirm: @escaping () -> Void, onCancel: @escaping () -> Void) -> MTGConfirmationDialog {
        MTGConfirmationDialog(
            title: "Leave the Battlefield?",
            message: "Your current game will be abandoned. Are you sure you want to concede?",
            confirmText: "Concede",
            cancelText: "Stay",
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
}

// Custom button style for MTG-themed buttons
struct MTGButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Preview
#Preview {
    MTGConfirmationDialog(
        title: "Reset the Battlefield?",
        message: "This will reset all life totals and start a new game. Your current progress will be lost to the void.",
        confirmText: "Cast",
        cancelText: "Counter",
        onConfirm: {},
        onCancel: {}
    )
}
