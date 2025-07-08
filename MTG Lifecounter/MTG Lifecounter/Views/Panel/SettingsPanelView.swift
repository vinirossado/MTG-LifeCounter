//
//  SettingsPanelView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado

import SwiftUI

// Panel dimensions - cached for performance
private struct PanelDimensions {
  static let shared = PanelDimensions()
  
  let screenWidth = UIScreen.main.bounds.width
  let screenHeight = UIScreen.main.bounds.height
  
  var settingsPanelWidth: CGFloat {
    // iPad: 1/3 of screen, iPhone: 80% of screen
    return isIPad ? screenWidth / 3 : screenWidth * 0.8
  }
  
  var settingsPanelHeight: CGFloat {
    // Used for iPhone in landscape
    return screenHeight * 0.7
  }
}

public var settingsPanelWidth: CGFloat {
  PanelDimensions.shared.settingsPanelWidth
}

public var settingsPanelHeight: CGFloat {
  PanelDimensions.shared.settingsPanelHeight
}

struct SettingsPanelView: View {
  @Binding var selectedTab: Int
  @State private var isVisible = false
  @State private var mysticalGlow: Double = 0.3
  
  // Cached gradients for performance
  private let backgroundGradient = LinearGradient(
    colors: [
      Color.darkNavyBackground,
      Color.oceanBlueBackground.opacity(0.95),
      Color.darkNavyBackground
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  private let borderGradient = LinearGradient(
    colors: [
      Color.blue.opacity(0.6),
      Color.purple.opacity(0.4),
      Color.blue.opacity(0.6)
    ],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Mystical background overlay
        Color.black.opacity(0.8)
          .ignoresSafeArea()
          .onTapGesture {
            withAnimation(.easeInOut(duration: 0.4)) {
              selectedTab = 0
            }
          }

        // Settings grimoire
        VStack(spacing: 0) {
          // MTG-themed settings content
          MTGSettingsPanelContent()
            .frame(
              width: isIPad ? settingsPanelWidth : geometry.size.width - 40,
              height: isIPad ? geometry.size.height : settingsPanelHeight
            )
            .background(
              // Spell book/grimoire appearance
              RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(backgroundGradient)
                .overlay(
                  RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderGradient, lineWidth: 2)
                )
                .shadow(color: Color.blue.opacity(mysticalGlow), radius: 15, x: 0, y: 5)
                .shadow(color: Color.black.opacity(0.6), radius: 25, x: 0, y: 10)
            )
            .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: isIPad ? .trailing : .bottom
            )
            .padding(.bottom, isIPad ? 0 : 20)
            .transition(.move(edge: isIPad ? .trailing : .bottom))
            .scaleEffect(isVisible ? 1.0 : 0.9)
            .opacity(isVisible ? 1.0 : 0.0)
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
      .onAppear {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
          isVisible = true
        }
        
        // Optimized mystical glow animation - less frequent updates
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
          mysticalGlow = 0.6
        }
      }
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

// Environment keys for settings change requests
struct RequestLayoutChangeKey: EnvironmentKey {
  static let defaultValue: (PlayerLayouts) -> Void = { _ in }
}

struct RequestLifePointsChangeKey: EnvironmentKey {
  static let defaultValue: (Int) -> Void = { _ in }
}

extension EnvironmentValues {
  var requestLayoutChange: (PlayerLayouts) -> Void {
    get { self[RequestLayoutChangeKey.self] }
    set { self[RequestLayoutChangeKey.self] = newValue }
  }
  
  var requestLifePointsChange: (Int) -> Void {
    get { self[RequestLifePointsChangeKey.self] }
    set { self[RequestLifePointsChangeKey.self] = newValue }
  }
}

// MTG-Themed Settings Panel Content
struct MTGSettingsPanelContent: View {
  @EnvironmentObject var gameSettings: GameSettings

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: adaptiveSpacing * 1.5) {
        // Mystical header
        VStack(spacing: 12) {
          // Decorative header with mana symbols
          HStack {
            Circle()
              .fill(LinearGradient(
                colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ))
              .frame(width: 10, height: 10)
              .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
            
            Rectangle()
              .fill(LinearGradient(
                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
              ))
              .frame(height: 1.5)
            
            Text("⚡")
              .font(.system(size: 16))
              .foregroundColor(.yellow.opacity(0.8))
            
            Rectangle()
              .fill(LinearGradient(
                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                startPoint: .leading,
                endPoint: .trailing
              ))
              .frame(height: 1.5)
            
            Circle()
              .fill(LinearGradient(
                colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              ))
              .frame(width: 10, height: 10)
              .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
          }
          
          Text("Spell Configuration")
            .font(.system(size: adaptiveTitleSize, weight: .bold, design: .serif))
            .foregroundStyle(
              LinearGradient(
                colors: [Color.white, Color.lightGrayText],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
        }
        .padding(.bottom, adaptiveSpacing)

        // Battlefield Layout section
        MTGSectionContainer(standardStyle: {
          VStack(alignment: .leading, spacing: adaptiveSpacing) {
            MTGSectionHeader.playerLayout()

            // Layout Grid with mystical styling
            MTGPlayerLayoutsGrid()
          }
        })

        // Life Force section
        MTGSectionContainer(lifeThemed: {
          VStack(alignment: .leading, spacing: adaptiveSpacing) {
            MTGSectionHeader.lifePoints()

            // Life Points with mystical styling
            MTGLifePointsView()
          }
        })

        // Screen Wake Settings section
        MTGSectionContainer(commanderThemed: {
          VStack(alignment: .leading, spacing: adaptiveSpacing) {
            MTGSectionHeader.screenControl()

            // Screen Wake Toggle with mystical styling
            MTGScreenWakeToggle()
          }
        })
      }
      .padding(adaptivePadding)
    }
  }
}

// MTG-themed player layouts grid with performance optimizations
struct MTGPlayerLayoutsGrid: View {
  @EnvironmentObject var gameSettings: GameSettings
  @Environment(\.requestLayoutChange) private var requestLayoutChange
  
  private let layouts: [PlayerLayouts] = [
    .two, .threeLeft, .threeRight, .four, .five, .six
  ]
  
  // Cached columns array for performance
  private let gridColumns = Array(
    repeating: GridItem(.flexible(), spacing: adaptiveGridSpacing),
    count: adaptiveGridColumns
  )
  
  var body: some View {
    LazyVGrid(
      columns: gridColumns,
      spacing: adaptiveGridSpacing
    ) {
      ForEach(layouts, id: \.self) { layout in
        MTGPlayerLayout(
          isSelected: gameSettings.layout == layout,
          onClick: {
            if gameSettings.layout != layout {
              requestLayoutChange(layout)
            }
          },
          players: layout
        )
      }
    }
  }
}

// MTG-themed player layout component with performance optimizations
struct MTGPlayerLayout: View {
    let isSelected: Bool
    let onClick: () -> Void
    let players: PlayerLayouts
    @State private var mysticalGlow: Double = 0.2
    
    // Cached gradients for performance
    private var selectedGradient: LinearGradient {
      LinearGradient(
        colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.4)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
    
    private var unselectedGradient: LinearGradient {
      LinearGradient(
        colors: [Color.oceanBlueBackground.opacity(0.8), Color.darkNavyBackground.opacity(0.9)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
    
    private var selectedBorderGradient: LinearGradient {
      LinearGradient(
        colors: [Color.blue.opacity(0.8), Color.yellow.opacity(0.6)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
    
    private var unselectedBorderGradient: LinearGradient {
      LinearGradient(
        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.2)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
    }
    
    var body: some View {
        // Use @ViewBuilder for better performance instead of AnyView
        let grid = createGridView(for: players)
        
        Button(action: onClick) {
            VStack(spacing: 8) {
                // Card-like frame for the layout preview
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? selectedGradient : unselectedGradient)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    isSelected ? selectedBorderGradient : unselectedBorderGradient,
                                    lineWidth: isSelected ? 2 : 1
                                )
                        )
                        .shadow(
                            color: isSelected 
                                ? Color.blue.opacity(mysticalGlow) 
                                : Color.black.opacity(0.2), 
                            radius: isSelected ? 8 : 4, 
                            x: 0, 
                            y: 2
                        )
                    
                    grid
                        .scaleEffect(0.8)
                }
                .frame(height: 60)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
                
                // Mystical player count indicator
                HStack(spacing: 4) {
                    Text("\(players.playerCount)")
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .foregroundColor(isSelected ? .yellow.opacity(0.9) : .lightGrayText)
                    
                    Image(systemName: "person.fill")
                        .font(.system(size: 10))
                        .foregroundColor(isSelected ? .yellow.opacity(0.7) : .mutedSilverText)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(
                            isSelected 
                                ? Color.blue.opacity(0.3)
                                : Color.oceanBlueBackground.opacity(0.4)
                        )
                        .overlay(
                            Capsule()
                                .stroke(
                                    isSelected 
                                        ? Color.yellow.opacity(0.4)
                                        : Color.blue.opacity(0.2),
                                    lineWidth: 1
                                )
                        )
                )
            }
        }
        .buttonStyle(MTGPressableButtonStyle())
        .onAppear {
            // Only animate if selected and reduce animation frequency
            if isSelected {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    mysticalGlow = 0.6
                }
            }
        }
        .onChange(of: isSelected) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    mysticalGlow = 0.6
                }
            } else {
                mysticalGlow = 0.2
            }
        }
    }
    
    // Replace AnyView with direct view creation for better performance
    @ViewBuilder
    private func createGridView(for players: PlayerLayouts) -> some View {
        switch players {
        case .two:
            TwoPlayerGridView()
        case .threeLeft:
            ThreePlayerLeftGridView()
        case .threeRight:
            ThreePlayerRightGridView()
        case .four:
            FourPlayerGridView()
        case .five:
            FivePlayerGridView()
        case .six:
            SixPlayerGridView()
        }
    }
}

// MTG-themed life points view with performance optimizations
struct MTGLifePointsView: View {
  @EnvironmentObject var gameSettings: GameSettings
  @Environment(\.requestLifePointsChange) private var requestLifePointsChange
  let lifePointsOptions = [20, 25, 40]
  @State private var customLifeValue: String = ""
  @State private var isCustomInputFocused: Bool = false
  @FocusState private var isTextFieldFocused: Bool
  
  // Cached gradients for performance
  private let selectedGradient = LinearGradient(
    colors: [Color.red.opacity(0.6), Color.red.opacity(0.4)],
    startPoint: .top,
    endPoint: .bottom
  )
  
  private let unselectedGradient = LinearGradient(
    colors: [Color.oceanBlueBackground.opacity(0.6), Color.darkNavyBackground.opacity(0.8)],
    startPoint: .top,
    endPoint: .bottom
  )
  
  private let selectedBorderGradient = LinearGradient(
    colors: [Color.red.opacity(0.8), Color.yellow.opacity(0.6)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  private let unselectedBorderGradient = LinearGradient(
    colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )
  
  private let disabledGradient = LinearGradient(
    colors: [Color.oceanBlueBackground.opacity(0.3), Color.darkNavyBackground.opacity(0.4)],
    startPoint: .top,
    endPoint: .bottom
  )
  
  private let disabledBorderGradient = LinearGradient(
    colors: [Color.blue.opacity(0.15), Color.purple.opacity(0.15)],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
  )

  var body: some View {
    VStack(spacing: 16) {
      // Preset life point options
      LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
        ForEach(lifePointsOptions, id: \.self) { points in
          Button(action: {
            if gameSettings.startingLife != points {
              requestLifePointsChange(points)
              // Clear custom input when preset is selected
              customLifeValue = ""
              isTextFieldFocused = false
            }
          }) {
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .fill(gameSettings.startingLife == points ? selectedGradient : unselectedGradient)
                .overlay(
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(
                      gameSettings.startingLife == points ? selectedBorderGradient : unselectedBorderGradient,
                      lineWidth: gameSettings.startingLife == points ? 2 : 1
                    )
                )
                .shadow(
                  color: gameSettings.startingLife == points 
                    ? Color.red.opacity(0.4) 
                    : Color.blue.opacity(0.2), 
                  radius: gameSettings.startingLife == points ? 6 : 3, 
                  x: 0, 
                  y: 2
                )
                .animation(.easeInOut(duration: 0.2), value: gameSettings.startingLife)

              Text("\(points)")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .frame(height: 80)
            .scaleEffect(gameSettings.startingLife == points ? 1.05 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: gameSettings.startingLife)
          }
          .buttonStyle(MTGPressableButtonStyle())
        }
      }
      
      // Custom life input section
      VStack(alignment: .leading, spacing: 8) {
        Text("Custom Life Total")
          .font(.system(size: 16, weight: .semibold, design: .serif))
          .foregroundColor(.lightGrayText)
        
        // Custom input field with apply button
        HStack(spacing: 12) {
          // Input field
          ZStack {
            RoundedRectangle(cornerRadius: 8)
              .fill(isCustomSelected ? selectedGradient : unselectedGradient)
              .overlay(
                RoundedRectangle(cornerRadius: 8)
                  .stroke(
                    isCustomSelected ? selectedBorderGradient : unselectedBorderGradient,
                    lineWidth: isCustomSelected ? 2 : 1
                  )
              )
              .shadow(
                color: isCustomSelected 
                  ? Color.red.opacity(0.4) 
                  : Color.blue.opacity(0.2), 
                radius: isCustomSelected ? 6 : 3, 
                x: 0, 
                y: 2
              )
              .animation(.easeInOut(duration: 0.2), value: isCustomSelected)
            
            TextField("Enter life total", text: $customLifeValue)
              .focused($isTextFieldFocused)
              .keyboardType(.numberPad)
              .font(.system(size: 20, weight: .bold, design: .serif))
              .foregroundColor(.white)
              .multilineTextAlignment(.center)
              .onChange(of: customLifeValue) { _, newValue in
                // Filter out non-numeric characters only
                let filtered = newValue.filter { $0.isNumber }
                if filtered != newValue {
                  customLifeValue = filtered
                }
              }
          }
          .frame(height: 80)
          .scaleEffect(isCustomSelected ? 1.05 : 1.0)
          .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isCustomSelected)
          
          // Apply button
          Button(action: {
            handleCustomLifeInput()
            isTextFieldFocused = false
          }) {
            ZStack {
              RoundedRectangle(cornerRadius: 8)
                .fill(canApplyCustomValue ? selectedGradient : disabledGradient)
                .overlay(
                  RoundedRectangle(cornerRadius: 8)
                    .stroke(
                      canApplyCustomValue ? selectedBorderGradient : disabledBorderGradient,
                      lineWidth: 1
                    )
                )
                .shadow(
                  color: canApplyCustomValue 
                    ? Color.red.opacity(0.4) 
                    : Color.blue.opacity(0.1), 
                  radius: canApplyCustomValue ? 6 : 2, 
                  x: 0, 
                  y: 2
                )
                .animation(.easeInOut(duration: 0.2), value: canApplyCustomValue)
              
              Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(canApplyCustomValue ? .white : .gray.opacity(0.6))
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
            }
            .frame(width: 80, height: 80)
            .scaleEffect(canApplyCustomValue ? 1.0 : 0.95)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: canApplyCustomValue)
          }
          .buttonStyle(MTGPressableButtonStyle())
          .disabled(!canApplyCustomValue)
        }
      }
    }
  }
  
  // Computed property to check if custom value is selected
  private var isCustomSelected: Bool {
    if let customLife = Int(customLifeValue), customLife > 0 {
      return gameSettings.startingLife == customLife && !lifePointsOptions.contains(customLife)
    }
    return isTextFieldFocused
  }
  
  // Computed property to check if custom value can be applied
  private var canApplyCustomValue: Bool {
    guard let life = Int(customLifeValue), life > 0 else { return false }
    return gameSettings.startingLife != life
  }
  
  // Handle custom life input submission
  private func handleCustomLifeInput() {
    guard let life = Int(customLifeValue), life > 0 else {
      // Reset to current setting if invalid
      if lifePointsOptions.contains(gameSettings.startingLife) {
        customLifeValue = ""
      } else {
        customLifeValue = "\(gameSettings.startingLife)"
      }
      return
    }
    
    if gameSettings.startingLife != life {
      requestLifePointsChange(life)
    }
  }
}

// MTG-themed Screen Wake Toggle with performance optimizations
struct MTGScreenWakeToggle: View {
  @EnvironmentObject var screenWakeManager: ScreenWakeManager
  @State private var mysticalGlow: Double = 0.2
  
  // Cached gradients for performance
  private let activeGradient = LinearGradient(
    colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)],
    startPoint: .leading,
    endPoint: .trailing
  )
  
  private let inactiveGradient = LinearGradient(
    colors: [Color.gray.opacity(0.6), Color.gray.opacity(0.4)],
    startPoint: .leading,
    endPoint: .trailing
  )
  
  var body: some View {
    HStack {
      VStack(alignment: .leading, spacing: 4) {
        Text("Keep Screen Awake")
          .font(.system(size: 16, weight: .semibold, design: .serif))
          .foregroundColor(.lightGrayText)
        
        Text(screenWakeManager.isScreenAwake ? "Screen will stay on" : "Normal sleep behavior")
          .font(.system(size: 12, design: .serif))
          .foregroundColor(.mutedSilverText)
          .italic()
      }
      
      Spacer()
      
      // MTG-themed toggle switch
      Button(action: {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
          screenWakeManager.toggleScreenWake()
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
      }) {
        ZStack {
          // Background track
          RoundedRectangle(cornerRadius: 20)
            .fill(screenWakeManager.isScreenAwake ? activeGradient : inactiveGradient)
            .frame(width: 60, height: 32)
            .overlay(
              RoundedRectangle(cornerRadius: 20)
                .stroke(
                  screenWakeManager.isScreenAwake 
                    ? Color.yellow.opacity(0.8)
                    : Color.gray.opacity(0.4), 
                  lineWidth: 1
                )
            )
            .shadow(
              color: screenWakeManager.isScreenAwake 
                ? Color.yellow.opacity(mysticalGlow)
                : Color.black.opacity(0.2), 
              radius: screenWakeManager.isScreenAwake ? 8 : 2, 
              x: 0, 
              y: 2
            )
          
          // Toggle thumb with icon
          HStack {
            if screenWakeManager.isScreenAwake {
              Spacer()
            }
            
            ZStack {
              Circle()
                .fill(.white)
                .frame(width: 26, height: 26)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 0, y: 1)
              
              Image(systemName: screenWakeManager.isScreenAwake ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(screenWakeManager.isScreenAwake ? .yellow : .gray)
            }
            
            if !screenWakeManager.isScreenAwake {
              Spacer()
            }
          }
          .padding(.horizontal, 3)
          .frame(width: 60, height: 32)
        }
      }
      .buttonStyle(PlainButtonStyle())
    }
    .padding(.vertical, 8)
    .onAppear {
      // Reduced animation frequency for better performance
      withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
        mysticalGlow = 0.6
      }
    }
  }
}
