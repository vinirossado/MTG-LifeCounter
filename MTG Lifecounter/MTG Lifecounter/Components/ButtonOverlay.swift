//
//  ButtonOverlay.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

// MTG-themed button style with magical scale effect
struct MTGScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(MTGAnimation.quick, value: configuration.isPressed)
    }
}

struct MTGOverlayButton: View {
    let iconName: String
    let label: String
    let action: () -> Void
    let variant: ButtonVariant
    @State private var isHovered = false
    
    enum ButtonVariant {
        case primary, secondary, danger, success
        
        var gradient: LinearGradient {
            switch self {
            case .primary:
                return LinearGradient.MTG.primaryButton
            case .secondary:
                return LinearGradient.MTG.cardBackground
            case .danger:
                return LinearGradient.MTG.dangerButton
            case .success:
                return LinearGradient.MTG.successButton
            }
        }
        
        var glowColor: Color {
            switch self {
            case .primary:
                return Color.MTG.glowPrimary
            case .secondary:
                return Color.MTG.glowSecondary
            case .danger:
                return Color.MTG.red
            case .success:
                return Color.MTG.green
            }
        }
    }
    
    init(iconName: String, label: String, variant: ButtonVariant = .primary, action: @escaping () -> Void) {
        self.iconName = iconName
        self.label = label
        self.variant = variant
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: MTGSpacing.sm) {
                // Icon with mystical container
                ZStack {
                    RoundedRectangle(cornerRadius: MTGCornerRadius.md)
                        .fill(variant.gradient)
                        .frame(width: 60, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: MTGCornerRadius.md)
                                .stroke(LinearGradient.MTG.magicalGlow, lineWidth: MTGSpacing.borderWidth)
                                .opacity(0.6)
                        )
                        .mtgGlow(color: variant.glowColor, radius: isHovered ? 12 : 6)
                    
                    Image(systemName: iconName)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(LinearGradient.MTG.magicalGlow)
                }
                
                // Label with MTG typography
                Text(label)
                    .font(MTGTypography.caption)
                    .foregroundColor(Color.MTG.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(MTGScaleButtonStyle())
        .onHover { hovering in
            withAnimation(MTGAnimation.quick) {
                isHovered = hovering
            }
        }
    }
}

// Legacy compatibility wrapper
typealias OverlayButton = MTGOverlayButton
typealias ScaleButtonStyle = MTGScaleButtonStyle
