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
    switch layout {
    case .two:
      return AnyView(TwoPlayerLayout())
    case .threeLeft:
      return AnyView(ThreePlayerLayoutLeft())
    case .threeRight:
      return AnyView(ThreePlayerLayoutRight())
    case .four:
      return AnyView(FourPlayerLayout())
    case .five:
      return AnyView(FivePlayerLayout())
    case .six:
      return AnyView(SixPlayerLayout())
    }
  }
}

// MARK: - Main View
struct GameView: View {
    @EnvironmentObject var gameSettings: GameSettings
    @EnvironmentObject var playerState: PlayerState
    @State private var previousLayout: PlayerLayouts?
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
                // Main Game Layout
                GameLayoutBuilder.buildLayout(layout: gameSettings.layout)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
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
                        .transition(.move(edge: settingsButtonPosition))
                        .zIndex(1)
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                playerState.initialize(gameSettings: gameSettings)
            }
            .onChange(of: gameSettings.startingLife) { oldValue, newValue in
                handleSettingsChange(previousLayout: gameSettings.layout)
            }
            .onChange(of: gameSettings.layout) { oldValue, newValue in
                handleSettingsChange(previousLayout: oldValue)
            }
            .alert("Attention!", isPresented: $showingResetAlert) {
                Button("Yes") {
                    playerState.initialize(gameSettings: gameSettings)
                    showingResetAlert = false
                }
                Button("No", role: .cancel) {
                    if let prevLayout = previousLayout {
                        gameSettings.layout = prevLayout
                    }
                }
            } message: {
                Text("Do you want to reset the game?")
            }
        }
        .ignoresSafeArea(.keyboard)
    }
        
    // Settings Button
    private var settingsButton: some View {
        Button(action: {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                selectedTab = selectedTab == 0 ? 1 : 0
            }
        }) {
            Image(systemName: selectedTab == 1 ? "xmark.circle.fill" : "gear")
                .font(.system(size: adaptiveIconSize))
                .foregroundColor(.white)
                .padding(adaptiveButtonPadding)
                .background(Color.black.opacity(0.1))
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .accessibilityLabel(selectedTab == 1 ? "Close Settings" : "Open Settings")
    }
        

    private func handleSettingsChange(previousLayout: PlayerLayouts) {
        showingResetAlert = true
        self.previousLayout = previousLayout
    }
}
