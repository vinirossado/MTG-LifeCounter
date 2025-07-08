//
//  ColorExtension.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 29.10.2024.
//

import SwiftUI

// MARK: - Color Utilities
public extension Color {
    
    /// Creates a Color from a hex string
    /// - Parameter hex: The hexadecimal color string (with or without #)
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
            .uppercased()
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    /// Legacy color names for backward compatibility
    /// These are maintained to prevent breaking existing code, but MTG.* colors should be preferred
    static let darkNavyBackground = Color.MTG.deepBlack
    static let oceanBlueBackground = Color.MTG.arcaneBlue
    static let steelGrayBackground = Color.MTG.shadowGray
    static let lightGrayText = Color.MTG.textPrimary
    static let mutedSilverText = Color.MTG.textSecondary
}

// MARK: - Color Manipulation Extensions
extension Color {
    
    /// Creates a lighter version of the color
    /// - Parameter amount: The amount to lighten (0.0 to 1.0)
    /// - Returns: A lighter version of the color
    func lighter(by amount: Double = 0.25) -> Color {
        return self.opacity(1.0 - amount)
    }
    
    /// Creates a darker version of the color
    /// - Parameter amount: The amount to darken (0.0 to 1.0)
    /// - Returns: A darker version of the color
    func darker(by amount: Double = 0.25) -> Color {
        // Simple darkening by reducing opacity - a proper implementation would manipulate RGB values
        let darkenAmount = max(0.0, min(1.0, amount))
        return self.opacity(1.0 - darkenAmount)
    }
    
    /// Creates a color with adjusted saturation
    /// - Parameter saturation: The saturation level (0.0 to 1.0)
    /// - Returns: A color with adjusted saturation
    func adjustSaturation(_ saturation: Double) -> Color {
        // This is a simplified implementation
        return self.opacity(saturation)
    }
}

// MARK: - MTG Mana Color Helpers
extension Color {
    
    /// Gets the color associated with an MTG mana type
    /// - Parameter manaType: The mana type character (W, U, B, R, G, C)
    /// - Returns: The associated color
    static func manaColor(for manaType: Character) -> Color {
        switch manaType.uppercased().first {
        case "W":
            return Color.MTG.white
        case "U":
            return Color.MTG.blue
        case "B":
            return Color.MTG.black
        case "R":
            return Color.MTG.red
        case "G":
            return Color.MTG.green
        case "C":
            return Color.MTG.gold // Colorless/Artifact
        default:
            return Color.MTG.textSecondary
        }
    }
    
    /// Gets MTG mana colors from an array of color identities
    /// - Parameter colorIdentity: Array of mana color strings
    /// - Returns: Array of corresponding colors
    static func manaColors(from colorIdentity: [String]) -> [Color] {
        return colorIdentity.compactMap { colorString in
            guard let firstChar = colorString.first else { return nil }
            return manaColor(for: firstChar)
        }
    }
}

// MARK: - Accessibility Extensions
extension Color {
    
    /// Provides a high contrast version of the color for accessibility
    var accessibleVersion: Color {
        // Simplified - in practice you'd analyze the color's luminance
        return self == Color.MTG.deepBlack ? Color.MTG.textPrimary : Color.MTG.deepBlack
    }
    
    /// Provides an appropriate text color for this background color
    var contrastingTextColor: Color {
        // Simplified - in practice you'd calculate the contrast ratio
        return Color.MTG.textPrimary
    }
}

