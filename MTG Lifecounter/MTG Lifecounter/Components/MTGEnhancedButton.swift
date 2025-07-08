//
//  MTGEnhancedButton.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 08/07/25.
//

import SwiftUI

// MARK: - Button Style Enumeration
enum MTGButtonStyle: String, CaseIterable {
    case primary = "primary"
    case secondary = "secondary"
    case danger = "danger"
    case success = "success"
    case mana = "mana"
    case ghost = "ghost"
    
    var gradient: LinearGradient {
        switch self {
        case .primary:
            return LinearGradient.MTG.primaryButton
        case .secondary:
            return LinearGradient(
                colors: [Color.MTG.shadowGray, Color.MTG.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .danger:
            return LinearGradient.MTG.dangerButton
        case .success:
            return LinearGradient.MTG.successButton
        case .mana:
            return LinearGradient.MTG.magicalGlow
        case .ghost:
            return LinearGradient(
                colors: [Color.clear, Color.clear],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    var textColor: Color {
        switch self {
        case .primary, .secondary, .danger, .success, .mana:
            return Color.MTG.textPrimary
        case .ghost:
            return Color.MTG.textSecondary
        }
    }
    
    var borderColor: Color {
        switch self {
        case .ghost:
            return Color.MTG.textSecondary.opacity(0.3)
        default:
            return Color.clear
        }
    }
}

// MARK: - Enhanced MTG Button
struct MTGEnhancedButton: View {
    
    // MARK: - Properties
    let title: String
    let iconName: String?
    let style: MTGButtonStyle
    let size: ButtonSize
    let isEnabled: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    @State private var isHovered = false
    
    // MARK: - Size Configuration
    enum ButtonSize {
        case small
        case medium
        case large
        case custom(width: CGFloat?, height: CGFloat)
        
        var height: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return MTGLayout.buttonHeight
            case .large: return 56
            case .custom(_, let height): return height
            }
        }
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 18
            case .custom: return 16
            }
        }
        
        var horizontalPadding: CGFloat {
            switch self {
            case .small: return MTGSpacing.sm
            case .medium: return MTGSpacing.md
            case .large: return MTGSpacing.lg
            case .custom: return MTGSpacing.md
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            case .custom: return 16
            }
        }
    }
    
    // MARK: - Initializer
    init(
        title: String,
        iconName: String? = nil,
        style: MTGButtonStyle = .primary,
        size: ButtonSize = .medium,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.iconName = iconName
        self.style = style
        self.size = size
        self.isEnabled = isEnabled
        self.action = action
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: {
            guard isEnabled else { return }
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            withAnimation(MTGAnimation.quick) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(MTGAnimation.quick) {
                    isPressed = false
                }
                action()
            }
        }) {
            buttonContent
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .onHover { hovering in
            withAnimation(MTGAnimation.quick) {
                isHovered = hovering
            }
        }
        .accessibilityLabel(title)
        .accessibilityElement(children: .ignore)
        .accessibilityValue(isEnabled ? "Enabled" : "Disabled")
    }
    
    // MARK: - Private Views
    
    private var buttonContent: some View {
        HStack(spacing: MTGSpacing.xs) {
            // Icon (if provided)
            if let iconName = iconName {
                Image(systemName: iconName)
                    .font(.system(size: size.iconSize, weight: .medium))
                    .foregroundColor(style.textColor)
            }
            
            // Title
            Text(title)
                .font(.system(size: size.fontSize, weight: .semibold))
                .foregroundColor(style.textColor)
                .lineLimit(1)
        }
        .padding(.horizontal, size.horizontalPadding)
        .frame(height: size.height)
        .frame(maxWidth: maxWidth)
        .background(backgroundView)
        .overlay(borderOverlay)
        .cornerRadius(MTGCornerRadius.button)
        .scaleEffect(buttonScale)
        .opacity(buttonOpacity)
        .animation(MTGAnimation.standardSpring, value: isPressed)
        .animation(MTGAnimation.standardSpring, value: isHovered)
        .animation(MTGAnimation.standardSpring, value: isEnabled)
    }
    
    private var backgroundView: some View {
        Group {
            if style == .ghost {
                Color.clear
            } else {
                style.gradient
            }
        }
    }
    
    private var borderOverlay: some View {
        Group {
            if style == .ghost {
                RoundedRectangle(cornerRadius: MTGCornerRadius.button)
                    .stroke(style.borderColor, lineWidth: MTGSpacing.borderWidth)
            } else {
                EmptyView()
            }
        }
    }
    
    private var maxWidth: CGFloat? {
        switch size {
        case .custom(let width, _):
            return width
        default:
            return nil
        }
    }
    
    private var buttonScale: CGFloat {
        if !isEnabled {
            return 0.95
        } else if isPressed {
            return 0.96
        } else if isHovered {
            return 1.02
        } else {
            return 1.0
        }
    }
    
    private var buttonOpacity: Double {
        isEnabled ? 1.0 : 0.6
    }
}

// MARK: - Convenience Initializers
extension MTGEnhancedButton {
    
    /// Creates a primary action button
    static func primary(
        title: String,
        iconName: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> MTGEnhancedButton {
        MTGEnhancedButton(
            title: title,
            iconName: iconName,
            style: .primary,
            size: size,
            action: action
        )
    }
    
    /// Creates a danger/destructive action button
    static func danger(
        title: String,
        iconName: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> MTGEnhancedButton {
        MTGEnhancedButton(
            title: title,
            iconName: iconName,
            style: .danger,
            size: size,
            action: action
        )
    }
    
    /// Creates a success/confirmation button
    static func success(
        title: String,
        iconName: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> MTGEnhancedButton {
        MTGEnhancedButton(
            title: title,
            iconName: iconName,
            style: .success,
            size: size,
            action: action
        )
    }
    
    /// Creates a magical/mana-themed button
    static func magical(
        title: String,
        iconName: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> MTGEnhancedButton {
        MTGEnhancedButton(
            title: title,
            iconName: iconName,
            style: .mana,
            size: size,
            action: action
        )
    }
    
    /// Creates a ghost/outline button
    static func ghost(
        title: String,
        iconName: String? = nil,
        size: ButtonSize = .medium,
        action: @escaping () -> Void
    ) -> MTGEnhancedButton {
        MTGEnhancedButton(
            title: title,
            iconName: iconName,
            style: .ghost,
            size: size,
            action: action
        )
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: MTGSpacing.md) {
        MTGEnhancedButton.primary(
            title: "Cast Spell",
            iconName: "flame.fill"
        ) {
            print("Primary button tapped")
        }
        
        MTGEnhancedButton.danger(
            title: "Destroy",
            iconName: "xmark.circle.fill",
            size: .small
        ) {
            print("Danger button tapped")
        }
        
        MTGEnhancedButton.magical(
            title: "Planeswalker Spark",
            iconName: "sparkles",
            size: .large
        ) {
            print("Magical button tapped")
        }
        
        MTGEnhancedButton.ghost(
            title: "Cancel",
            size: .medium
        ) {
            print("Ghost button tapped")
        }
    }
    .padding()
    .background(Color.MTG.deepBlack)
}
