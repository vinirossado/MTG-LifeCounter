//
//  MTGSectionContainer.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 07.07.2025.
//

import SwiftUI

/// A reusable MTG-themed section container that provides consistent styling
/// for content sections throughout the app
struct MTGSectionContainer<Content: View>: View {
    let content: Content
    let borderColor: LinearGradient
    let backgroundColor: Color
    let padding: CGFloat
    
    init(
        borderColor: LinearGradient = LinearGradient(
            colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ),
        backgroundColor: Color = Color.blue.opacity(0.1),
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.borderColor = borderColor
        self.backgroundColor = backgroundColor
        self.padding = padding
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(borderColor, lineWidth: 1)
                    )
            )
    }
}

/// Convenience initializers for common section styles
extension MTGSectionContainer {
    /// Section with standard blue-purple border gradient
    init(standardStyle content: @escaping () -> Content) {
        self.init(content: content)
    }
    
    /// Section with red-purple border gradient (for life-related sections)
    init(lifeThemed content: @escaping () -> Content) {
        self.init(
            borderColor: LinearGradient(
                colors: [Color.red.opacity(0.4), Color.purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            content: content
        )
    }
    
    /// Section with yellow-purple border gradient (for special/commander sections)  
    init(commanderThemed content: @escaping () -> Content) {
        self.init(
            borderColor: LinearGradient(
                colors: [Color.yellow.opacity(0.4), Color.purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            content: content
        )
    }
}
