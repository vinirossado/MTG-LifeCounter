//
//  MTGTextField.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 07.07.2025.
//

import SwiftUI

/// A reusable MTG-themed text field with consistent styling
struct MTGTextField: View {
    @Binding var text: String
    let placeholder: String
    let fontSize: CGFloat
    let cornerRadius: CGFloat
    
    init(
        text: Binding<String>,
        placeholder: String = "",
        fontSize: CGFloat = 22,
        cornerRadius: CGFloat = 12
    ) {
        self._text = text
        self.placeholder = placeholder
        self.fontSize = fontSize
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.system(size: fontSize, weight: .medium, design: .serif))
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.blue.opacity(0.3),
                                Color.blue.opacity(0.2)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 3)
            )
            .foregroundColor(Color.white)
    }
}
