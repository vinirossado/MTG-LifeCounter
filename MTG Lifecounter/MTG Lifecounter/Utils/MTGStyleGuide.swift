//
//  MTGStyleGuide.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 15.11.2024.
//

import SwiftUI

/// Magic: The Gathering Themed UI Style Guide
/// This file contains all color schemes, gradients, typography, spacing, and animation constants
/// used throughout the MTG Lifecounter app to ensure visual consistency.

// MARK: - Colors
extension Color {
    
    /// Primary color palette based on MTG mana colors and mystical themes
    struct MTG {
        
        // MARK: - Base Colors
        static let deepBlack = Color(hex: "0B0F1A")
        static let richBlack = Color(hex: "1A1D2E")
        static let mysticalPurple = Color(hex: "2D1B3D")
        static let arcaneBlue = Color(hex: "1E2A5E")
        static let shadowGray = Color(hex: "2C2C3E")
        
        // MARK: - Mana-Inspired Colors
        static let white = Color(hex: "F8F6E8")      // Plains
        static let blue = Color(hex: "4A90E2")       // Island
        static let black = Color(hex: "1C1C1E")      // Swamp
        static let red = Color(hex: "D32F2F")        // Mountain
        static let green = Color(hex: "388E3C")      // Forest
        static let gold = Color(hex: "FFD700")       // Multicolored/Artifacts
        
        // MARK: - UI Element Colors
        static let cardBackground = Color(hex: "2A2D3A")
        static let cardBorder = Color(hex: "4A5568")
        static let glowPrimary = Color(hex: "8B5CF6")
        static let glowSecondary = Color(hex: "06B6D4")
        static let textPrimary = Color(hex: "F7FAFC")
        static let textSecondary = Color(hex: "A0AEC0")
        static let textAccent = Color(hex: "FFD700")
        
        // MARK: - Interaction Colors
        static let buttonPrimary = Color(hex: "5A67D8")
        static let buttonSecondary = Color(hex: "4C51BF")
        static let buttonDanger = Color(hex: "E53E3E")
        static let buttonSuccess = Color(hex: "38A169")
        
        // MARK: - Status Colors
        static let success = Color(hex: "48BB78")
        static let warning = Color(hex: "ED8936")
        static let error = Color(hex: "F56565")
        static let info = Color(hex: "4299E1")
    }
}

// MARK: - Gradients
extension LinearGradient {
    
    struct MTG {
        
        // MARK: - Background Gradients
        static let mysticalBackground = LinearGradient(
            colors: [Color.MTG.deepBlack, Color.MTG.mysticalPurple, Color.MTG.arcaneBlue],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let cardBackground = LinearGradient(
            colors: [Color.MTG.cardBackground, Color.MTG.shadowGray],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let spellScrollBackground = LinearGradient(
            colors: [Color(hex: "2A2D3A"), Color(hex: "1A1D2E"), Color(hex: "2A2D3A")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // MARK: - Mana Gradients
        static let whiteGradient = LinearGradient(
            colors: [Color.MTG.white.opacity(0.2), Color.MTG.white.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let blueGradient = LinearGradient(
            colors: [Color.MTG.blue.opacity(0.3), Color.MTG.blue.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let blackGradient = LinearGradient(
            colors: [Color.MTG.black.opacity(0.4), Color.MTG.black.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let redGradient = LinearGradient(
            colors: [Color.MTG.red.opacity(0.3), Color.MTG.red.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let greenGradient = LinearGradient(
            colors: [Color.MTG.green.opacity(0.3), Color.MTG.green.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // MARK: - Button Gradients
        static let primaryButton = LinearGradient(
            colors: [Color.MTG.buttonPrimary, Color.MTG.buttonSecondary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let dangerButton = LinearGradient(
            colors: [Color.MTG.buttonDanger, Color.MTG.buttonDanger.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        static let successButton = LinearGradient(
            colors: [Color.MTG.buttonSuccess, Color.MTG.buttonSuccess.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        
        // MARK: - Glow Effects
        static let magicalGlow = LinearGradient(
            colors: [Color.MTG.glowPrimary.opacity(0.6), Color.MTG.glowSecondary.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Typography
struct MTGTypography {
    
    // MARK: - Font Families
    static let primaryFont = "SF Pro Display"
    static let secondaryFont = "SF Pro Text"
    static let monospaceFont = "SF Mono"
    
    // MARK: - Font Styles
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.medium)
    static let headline = Font.headline.weight(.medium)
    static let body = Font.body.weight(.regular)
    static let callout = Font.callout.weight(.medium)
    static let caption = Font.caption.weight(.light)
    static let caption2 = Font.caption2.weight(.ultraLight)
    
    // MARK: - Custom Sizes
    static let heroTitle = Font.system(size: 32, weight: .bold, design: .default)
    static let cardTitle = Font.system(size: 18, weight: .semibold, design: .default)
    static let buttonText = Font.system(size: 16, weight: .medium, design: .default)
    static let lifeCounter = Font.system(size: 36, weight: .bold, design: .monospaced)
}

// MARK: - Spacing
struct MTGSpacing {
    
    // MARK: - Standard Spacing
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
    
    // MARK: - Component-Specific Spacing
    static let cardPadding: CGFloat = 16
    static let buttonPadding: CGFloat = 12
    static let sectionSpacing: CGFloat = 20
    static let elementSpacing: CGFloat = 12
    static let borderWidth: CGFloat = 1.5
    static let glowRadius: CGFloat = 8
}

// MARK: - Corner Radius
struct MTGCornerRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let card: CGFloat = 12
    static let button: CGFloat = 8
    static let overlay: CGFloat = 16
}

// MARK: - Shadows
struct MTGShadow {
    
    static let cardShadow = (
        color: Color.black.opacity(0.3),
        radius: CGFloat(8),
        x: CGFloat(0),
        y: CGFloat(4)
    )
    
    static let buttonShadow = (
        color: Color.black.opacity(0.2),
        radius: CGFloat(4),
        x: CGFloat(0),
        y: CGFloat(2)
    )
    
    static let glowShadow = (
        color: Color.MTG.glowPrimary.opacity(0.5),
        radius: CGFloat(12),
        x: CGFloat(0),
        y: CGFloat(0)
    )
    
    static let mysticalGlow = (
        color: Color.MTG.glowSecondary.opacity(0.4),
        radius: CGFloat(16),
        x: CGFloat(0),
        y: CGFloat(0)
    )
}

// MARK: - Animations
struct MTGAnimation {
    
    // MARK: - Spring Animations
    static let standardSpring = Animation.spring(response: 0.4, dampingFraction: 0.8)
    static let bounceSpring = Animation.spring(response: 0.6, dampingFraction: 0.6)
    static let gentleSpring = Animation.spring(response: 0.3, dampingFraction: 0.9)
    
    // MARK: - Timing Animations
    static let quick = Animation.easeInOut(duration: 0.2)
    static let medium = Animation.easeInOut(duration: 0.3)
    static let slow = Animation.easeInOut(duration: 0.5)
    
    // MARK: - Continuous Animations
    static let pulse = Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true)
    static let rotate = Animation.linear(duration: 8.0).repeatForever(autoreverses: false)
    static let breathe = Animation.easeInOut(duration: 3.0).repeatForever(autoreverses: true)
    
    // MARK: - Transition Animations
    static let slideIn = Animation.easeOut(duration: 0.4)
    static let fadeIn = Animation.easeInOut(duration: 0.3)
    static let scaleIn = Animation.spring(response: 0.5, dampingFraction: 0.7)
}

// MARK: - Icons
struct MTGIcons {
    
    // MARK: - System Icons with MTG Theme
    static let settings = "gearshape.fill"
    static let close = "xmark.circle.fill"
    static let reset = "arrow.clockwise.circle.fill"
    static let add = "plus.circle.fill"
    static let remove = "minus.circle.fill"
    static let edit = "pencil.circle.fill"
    static let check = "checkmark.circle.fill"
    static let warning = "exclamationmark.triangle.fill"
    static let info = "info.circle.fill"
    static let heart = "heart.fill"
    static let shield = "shield.fill"
    static let star = "star.fill"
    static let crown = "crown.fill"
    static let flame = "flame.fill"
    static let bolt = "bolt.fill"
    static let leaf = "leaf.fill"
    static let drop = "drop.fill"
    static let sparkles = "sparkles"
    
    // MARK: - Game-Specific Icons
    static let dice = "die.face.6.fill"
    static let cards = "rectangle.stack.fill"
    static let timer = "timer"
    static let players = "person.3.fill"
    static let gameController = "gamecontroller.fill"
}

// MARK: - Layout Constants
struct MTGLayout {
    
    // MARK: - Responsive Breakpoints
    static let compactWidth: CGFloat = 400
    static let regularWidth: CGFloat = 600
    static let largeWidth: CGFloat = 900
    
    // MARK: - Component Sizes
    static let buttonHeight: CGFloat = 44
    static let cardMinHeight: CGFloat = 120
    static let iconSize: CGFloat = 24
    static let largeIconSize: CGFloat = 32
    static let avatarSize: CGFloat = 60
    
    // MARK: - Grid Layouts
    static let gridItemSpacing: CGFloat = 12
    static let gridSectionSpacing: CGFloat = 20
}

// MARK: - Visual Effects
extension View {
    
    /// Apply MTG card-like styling with subtle glow and borders
    func mtgCardStyle() -> some View {
        self
            .background(LinearGradient.MTG.cardBackground)
            .overlay(
                RoundedRectangle(cornerRadius: MTGCornerRadius.card)
                    .stroke(LinearGradient.MTG.magicalGlow, lineWidth: MTGSpacing.borderWidth)
                    .opacity(0.6)
            )
            .cornerRadius(MTGCornerRadius.card)
            .shadow(
                color: MTGShadow.cardShadow.color,
                radius: MTGShadow.cardShadow.radius,
                x: MTGShadow.cardShadow.x,
                y: MTGShadow.cardShadow.y
            )
    }
    
    /// Apply mystical glow effect
    func mtgGlow(color: Color = Color.MTG.glowPrimary, radius: CGFloat = MTGSpacing.glowRadius) -> some View {
        self
            .shadow(color: color.opacity(0.5), radius: radius, x: 0, y: 0)
    }
    
    /// Apply MTG button styling
    func mtgButtonStyle(
        gradient: LinearGradient = LinearGradient.MTG.primaryButton,
        cornerRadius: CGFloat = MTGCornerRadius.button
    ) -> some View {
        self
            .background(gradient)
            .cornerRadius(cornerRadius)
            .shadow(
                color: MTGShadow.buttonShadow.color,
                radius: MTGShadow.buttonShadow.radius,
                x: MTGShadow.buttonShadow.x,
                y: MTGShadow.buttonShadow.y
            )
    }
    
    /// Apply responsive padding based on device size
    func mtgResponsivePadding() -> some View {
        self
            .padding(.horizontal, MTGSpacing.md)
            .padding(.vertical, MTGSpacing.sm)
    }
}

// MARK: - Style Guide Documentation
/*
 
 # MTG Lifecounter Style Guide
 
 ## Color Palette
 - **Primary**: Deep mystical blues and purples representing the magical nature of MTG
 - **Mana Colors**: Traditional MTG five-color system (WUBRG) + Gold for multicolor
 - **Neutrals**: Rich blacks and grays for backgrounds and text
 - **Accents**: Gold for highlights and important elements
 
 ## Typography
 - **Primary Font**: SF Pro Display for headers and important text
 - **Secondary Font**: SF Pro Text for body content
 - **Monospace**: SF Mono for numeric displays (life counters)
 - **Hierarchy**: Clear distinction between title, body, and caption text
 
 ## Spacing & Layout
 - **Consistent Spacing**: 8px grid system (4, 8, 16, 24, 32, 48, 64)
 - **Responsive Design**: Adapts to iPhone and iPad screen sizes
 - **Safe Areas**: Proper handling of notches and home indicators
 
 ## Visual Effects
 - **Subtle Glows**: Magical luminescence without overwhelming the interface
 - **Card-like Elements**: Rounded corners and shadows reminiscent of MTG cards
 - **Smooth Animations**: Spring-based animations for natural feel
 
 ## Accessibility
 - **High Contrast**: Ensure text is readable against magical backgrounds
 - **Touch Targets**: Minimum 44pt tap targets for all interactive elements
 - **Voice Over**: Proper labels and hints for screen reader users
 
 ## Theme Implementation
 - **Consistency**: All UI elements follow the same visual language
 - **Balance**: Magical theming without sacrificing usability
 - **Performance**: Optimized gradients and effects for smooth 60fps
 
 */
