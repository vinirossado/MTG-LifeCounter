//
//  MTGSectionHeader.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 07.07.2025.
//

import SwiftUI

/// A reusable MTG-themed section header with icon and description
struct MTGSectionHeader: View {
    let iconName: String
    let iconColor: Color
    let title: String
    let description: String
    let titleFontSize: CGFloat
    
    init(
        iconName: String,
        iconColor: Color = .blue.opacity(0.7),
        title: String,
        description: String,
        titleFontSize: CGFloat = 20
    ) {
        self.iconName = iconName
        self.iconColor = iconColor
        self.title = title
        self.description = description
        self.titleFontSize = titleFontSize
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: iconName)
                    .foregroundColor(iconColor)
                    .font(.system(size: 18))
                Text(title)
                    .font(.system(size: titleFontSize, weight: .semibold, design: .serif))
                    .foregroundColor(Color.white)
            }
            
            Text(description)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(Color.gray)
                .italic()
        }
    }
}

/// Convenience initializers for common header styles
extension MTGSectionHeader {
    /// Header for player layout sections
    static func playerLayout() -> MTGSectionHeader {
        MTGSectionHeader(
            iconName: "person.3.fill",
            iconColor: .blue.opacity(0.7),
            title: "Battlefield Layout",
            description: "Choose the number of planeswalkers"
        )
    }
    
    /// Header for life points sections
    static func lifePoints() -> MTGSectionHeader {
        MTGSectionHeader(
            iconName: "heart.fill",
            iconColor: .red.opacity(0.7),
            title: "Life Force",
            description: "Set starting life totals for all planeswalkers"
        )
    }
    
    /// Header for screen control sections
    static func screenControl() -> MTGSectionHeader {
        MTGSectionHeader(
            iconName: "sun.max.fill",
            iconColor: .yellow.opacity(0.7),
            title: "Screen Control",
            description: "Keep screen awake during gameplay"
        )
    }
    
    /// Header for player identity sections
    static func playerIdentity() -> MTGSectionHeader {
        MTGSectionHeader(
            iconName: "person.crop.circle.fill",
            iconColor: .blue.opacity(0.7),
            title: "Planeswalker Name",
            description: "Choose your identity in the multiverse"
        )
    }
    
    /// Header for commander sections
    static func commander() -> MTGSectionHeader {
        MTGSectionHeader(
            iconName: "crown.fill",
            iconColor: .yellow.opacity(0.8),
            title: "Commander",
            description: "Choose your legendary creature to lead your deck"
        )
    }
}
