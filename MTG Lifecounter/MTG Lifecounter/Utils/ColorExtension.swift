//
//  ColorExtension.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 29.10.2024.
//

import SwiftUI

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
    
    // Custom colors
    static let darkNavyBackground = Color(hex: "010c1e") // Background deep navy for main view
    static let oceanBlueBackground = Color(hex: "001e38") // Darker ocean blue for secondary elements
    static let steelGrayBackground = Color(hex: "4a6d88") // Soft steel gray for lighter backgrounds
    static let lightGrayText = Color(hex: "d5d9e0") // Light gray for primary text
    static let mutedSilverText = Color(hex: "c6cdd7") // Muted silver for secondary text

}

