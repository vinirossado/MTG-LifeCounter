//
//  File.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI
import UIKit

// Custom button style with scale effect
struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
      .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
  }
}

struct OverlayButton: View {
  let iconName: String
  let label: String
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack(spacing: 8) {
        Image(systemName: iconName)
          .font(.system(size: 28))
          .foregroundColor(.white)
          .frame(width: 60, height: 60)
          .background(
            LinearGradient(
              colors: [Color(hex: "4a6d88"), Color(hex: "375165")],
              startPoint: .top,
              endPoint: .bottom
            )
          )
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)

        Text(label)
          .font(.system(size: 14, weight: .medium))
          .foregroundColor(.white.opacity(0.9))
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
    }
    .buttonStyle(
      ScaleButtonStyle()
    )
  }
}
