//
//  SettingsPanelView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado

import SwiftUI

// Panel dimensions
public var settingsPanelWidth: CGFloat {
  let screenWidth = UIScreen.main.bounds.width
  // iPad: 1/3 of screen, iPhone: 80% of screen
  return isIPad ? screenWidth / 3 : screenWidth * 0.8
}

public var settingsPanelHeight: CGFloat {
  // Used for iPhone in landscape
  return UIScreen.main.bounds.height * 0.7
}

struct SettingsPanelView: View {
  @Binding var selectedTab: Int
  @Environment(\.dismissSettingsPanel) private var dismissPanel
    
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Semi-transparent background
        Color.black.opacity(0.5)
          .ignoresSafeArea()
          .onTapGesture {
              dismissPanel()
          }

        // Settings content
        VStack(spacing: 0) {
          // Settings content with adaptive layout
          SettingsPanelContent()
            .frame(
              width: isIPad ? settingsPanelWidth : geometry.size.width - 40,
              height: isIPad ? geometry.size.height : settingsPanelHeight
            )
            .background(
              Color.darkNavyBackground.opacity(0.95)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )
            .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: isIPad ? .trailing : .bottom
            )
            .padding(.bottom, isIPad ? 0 : 20)
            .transition(.move(edge: isIPad ? .trailing : .bottom))
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
    .ignoresSafeArea()
    .zIndex(2)
    // Pass the binding to child views via environment
    .environment(\.dismissSettingsPanel, dismissSettingsPanel)
  }
  
  private func dismissSettingsPanel() {
    withAnimation {
      selectedTab = 0
    }
  }
}

// Environment key to dismiss the settings panel
struct DismissSettingsPanelKey: EnvironmentKey {
  static let defaultValue: () -> Void = {}
}

extension EnvironmentValues {
  var dismissSettingsPanel: () -> Void {
    get { self[DismissSettingsPanelKey.self] }
    set { self[DismissSettingsPanelKey.self] = newValue }
  }
}

// Settings Panel Content
struct SettingsPanelContent: View {
//  @EnvironmentObject var gameSettings: GameSettings

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: adaptiveSpacing) {
        Text("Settings")
          .font(.system(size: adaptiveTitleSize, weight: .bold))
          .padding(.bottom, adaptiveSpacing * 1.5)
          .foregroundColor(.lightGrayText)

        Text("Players")
          .font(.system(size: adaptiveSubtitleSize, weight: .semibold))
          .padding(.bottom, adaptiveSpacing * 0.75)
          .foregroundColor(.lightGrayText)

        // Layout Grid - using the reusable component
        PlayerLayoutsGrid()

        // Life Points
        LifePointsView()
          .padding(.top, adaptiveSpacing)
      }
      .padding(adaptivePadding)
    }
  }
}

// Reusable player layouts grid to be shared between different views
struct PlayerLayoutsGrid: View {
  @EnvironmentObject var gameSettings: GameSettings
  
  private let layouts: [PlayerLayouts] = [
    .two, .threeLeft, .threeRight, .four, .five, .six
  ]
  
  var body: some View {
    LazyVGrid(
      columns: Array(
        repeating: GridItem(.flexible(), spacing: adaptiveGridSpacing),
        count: adaptiveGridColumns),
      spacing: adaptiveGridSpacing
    ) {
      ForEach(layouts, id: \.self) { layout in
        PlayerLayout(
          isSelected: gameSettings.layout == layout,
          onClick: {
            gameSettings.layout = layout
          },
          players: layout
        )
      }
    }
  }
}
