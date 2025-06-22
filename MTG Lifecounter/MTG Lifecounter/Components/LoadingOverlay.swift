//
//  LoadingOverlay.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 15.11.2024.
//

import SwiftUI

struct LoadingOverlay: View {
    
    @Binding var isShowing: Bool
    let message: String?
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            if isShowing {
                // Mystical background with blur effect
                LinearGradient.MTG.mysticalBackground
                    .opacity(0.8)
                    .ignoresSafeArea()
                    .overlay(
                        VisualEffectBlur(blurStyle: .systemMaterialDark)
                            .ignoresSafeArea()
                    )
                
                // Loading card with MTG styling
                VStack(spacing: MTGSpacing.lg) {
                    // Magical loading animation
                    LoadingAnimation(
                        colors: [Color.MTG.blue, Color.MTG.red, Color.MTG.green, Color.MTG.white, Color.MTG.black],
                        size: 120,
                        speed: 0.8,
                        circleCount: 5
                    )
                    
                    if let message = message {
                        VStack(spacing: MTGSpacing.sm) {
                            Text("Casting Spell...")
                                .font(MTGTypography.caption)
                                .foregroundColor(Color.MTG.textSecondary)
                            
                            Text(message)
                                .font(MTGTypography.headline)
                                .foregroundColor(Color.MTG.textPrimary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .mtgResponsivePadding()
                .mtgCardStyle()
                .scaleEffect(pulseScale)
                .animation(MTGAnimation.breathe, value: pulseScale)
                .onAppear {
                    pulseScale = 1.05
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(MTGAnimation.fadeIn, value: isShowing)
    }
}

// MTG-themed loading overlay extension
extension View {
    func mtgLoadingOverlay(isShowing: Binding<Bool>, message: String? = nil) -> some View {
        self.overlay(
            LoadingOverlay(isShowing: isShowing, message: message)
        )
    }
}

// Add suport ao Blur
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
