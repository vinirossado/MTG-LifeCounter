import SwiftUI

// MARK: - Layout Configuration
enum GameLayout {
  case twoPlayers
  case threePlayers
  case fourPlayers
  case fivePlayers
  case sixPlayers

  static func from(playerCount: Int) -> GameLayout? {
    switch playerCount {
    case 2: return .twoPlayers
    case 3: return .threePlayers
    case 4: return .fourPlayers
    case 5: return .fivePlayers
    case 6: return .sixPlayers
    default: return nil
    }
  }
}

// MARK: - Layout Builder
struct GameLayoutBuilder {
  static func buildLayout(layout: PlayerLayouts) -> some View {
    Group {
      switch layout {
      case .two:
        TwoPlayerLayout()
      case .threeLeft:
        ThreePlayerLayoutLeft()
      case .threeRight:
        ThreePlayerLayoutRight()
      case .four:
        FourPlayerLayout()
      case .five:
        FivePlayerLayout()
      case .six:
        SixPlayerLayout()
      }
    }
  }
}

// MARK: - Main View
struct GameView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var playerState: PlayerState
    @State private var pendingLayout: PlayerLayouts?
    @State private var pendingLifePoints: Int?
    @State private var showingResetAlert = false
    @State private var selectedTab = 0
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    // Always in landscape mode
    private var isLandscape: Bool {
        return true
    }
    
    private var settingsButtonPosition: Edge {
        // Settings button always on trailing edge
        return .trailing
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Background color to ensure full screen coverage
                Color.black
                    .ignoresSafeArea(.all)
                
                // Main Game Layout - Only render if player count matches expected layout
                if playerState.players.count >= gameSettings.layout.playerCount {
                    GameLayoutBuilder.buildLayout(layout: gameSettings.layout)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .id("GameLayout-\(gameSettings.layout)-\(playerState.players.count)") // Force refresh when layout or player count changes
                } else {
                    // Show loading state while player state catches up
                    VStack {
                        LoadingAnimation(
                            colors: [Color.MTG.blue, Color.MTG.red, Color.MTG.green, Color.MTG.white, Color.MTG.black],
                            size: 80,
                            speed: 0.8,
                            circleCount: 5
                        )
                        
                        Text("Preparing game layout...")
                            .font(MTGTypography.caption)
                            .foregroundColor(Color.MTG.textSecondary)
                            .padding(.top, MTGSpacing.md)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
                // Settings Button - Fixed position based on device orientation
                VStack {
                    HStack {
                        Spacer()
                        settingsButton
                    }
                    Spacer()
                }
                .padding(adaptivePadding)
                
                // Settings Sheet - Slides in from the side/bottom
                if selectedTab == 1 {
                    SettingsPanelView(selectedTab: $selectedTab)
                        .environmentObject(gameSettings)
                        .environment(\.requestLayoutChange, requestLayoutChange)
                        .environment(\.requestLifePointsChange, requestLifePointsChange)
                        .transition(.move(edge: settingsButtonPosition))
                        .zIndex(1)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .clipped()
            .navigationBarHidden(true)
            .onAppear {
                // Ensure player state matches current settings on view appear
                if playerState.players.count != gameSettings.layout.playerCount {
                    playerState.initialize(gameSettings: gameSettings)
                }
            }
                // MTG-themed confirmation dialog
                if showingResetAlert {
                    MTGConfirmationDialog.gameReset(
                        onConfirm: {
                            // First update the layout
                            if let newLayout = pendingLayout {
                                gameSettings.layout = newLayout
                            }
                            if let newLifePoints = pendingLifePoints {
                                gameSettings.startingLife = newLifePoints
                            }
                            
                            // Then immediately reinitialize player state to match the new layout
                            DispatchQueue.main.async {
                                playerState.initialize(gameSettings: gameSettings)
                            }
                            
                            // Clear pending changes
                            pendingLayout = nil
                            pendingLifePoints = nil
                            showingResetAlert = false
                        },
                        onCancel: {
                            pendingLayout = nil
                            pendingLifePoints = nil
                            showingResetAlert = false
                        }
                    )
                    .zIndex(10)
                }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.all)
        .ignoresSafeArea(.keyboard)
    }
        
    // Settings Button with MTG styling
    private var settingsButton: some View {
        Button(action: {
            withAnimation(MTGAnimation.standardSpring) {
                selectedTab = selectedTab == 0 ? 1 : 0
            }
        }) {
            ZStack {
                Circle()
                    .fill(LinearGradient.MTG.cardBackground)
                    .frame(width: adaptiveIconSize + MTGSpacing.md, height: adaptiveIconSize + MTGSpacing.md)
                    .overlay(
                        Circle()
                            .stroke(LinearGradient.MTG.magicalGlow, lineWidth: MTGSpacing.borderWidth)
                            .opacity(0.6)
                    )
                    .mtgGlow(color: Color.MTG.glowPrimary, radius: selectedTab == 1 ? 12 : 6)
                
                Image(systemName: selectedTab == 1 ? MTGIcons.close : MTGIcons.settings)
                    .font(.system(size: adaptiveIconSize * 0.6))
                    .foregroundStyle(LinearGradient.MTG.magicalGlow)
                    .rotationEffect(.degrees(selectedTab == 1 ? 90 : 0))
                    .animation(MTGAnimation.standardSpring, value: selectedTab)
            }
        }
        .accessibilityLabel(selectedTab == 1 ? "Close Settings" : "Open Settings")
    }
    
    private func requestLayoutChange(to newLayout: PlayerLayouts) {
        pendingLayout = newLayout
        showingResetAlert = true
    }
    
    private func requestLifePointsChange(to newLifePoints: Int) {
        pendingLifePoints = newLifePoints
        showingResetAlert = true
    }
}
