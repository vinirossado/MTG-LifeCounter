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

// MARK: - Simple Orientation Manager Replacement (Fixed Landscape)
private struct OrientationValues {
    static let isLandscape: Bool = true
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
    
    private var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // Always in landscape mode
    private var isLandscape: Bool {
        return OrientationValues.isLandscape
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
                    settingsPanel
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
    
    // MARK: - Components
    
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
    
    // Settings Panel
    private var settingsPanel: some View {
        GeometryReader { geometry in
            ZStack {
                // Semi-transparent background
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            selectedTab = 0
                        }
                    }
                
                // Settings content
                VStack(spacing: 0) {
                    // Settings content with adaptive layout
                    if isIPad {
                        // iPad - show from side
                        settingsPanelContent
                            .frame(width: settingsPanelWidth, height: geometry.size.height)
                            .background(
                                Color.darkNavyBackground.opacity(0.95)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            )
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .transition(.move(edge: .trailing))
                    } else {
                        // iPhone landscape - show from bottom as a shorter panel
                        settingsPanelContent
                            .frame(width: geometry.size.width - 40, height: settingsPanelHeight)
                            .background(
                                Color.darkNavyBackground.opacity(0.95)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            )
                            .frame(maxHeight: .infinity, alignment: .bottom)
                            .padding(.bottom, 20)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea()
        .zIndex(2)
    }
    
    //Settings Panel
    private var settingsPanelContent: some View {
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
                
                // Layout Grid
                layoutsGrid
                
                // Life Points
                LifePointsView()
                    .padding(.top, adaptiveSpacing)
            }
            .padding(adaptivePadding)
        }
    }
    
    // Layouts Grid
    private var layoutsGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: adaptiveGridSpacing), 
                           count: adaptiveGridColumns),
            spacing: adaptiveGridSpacing
        ) {
            PlayerLayout(isSelected: gameSettings.layout == .two, onClick: {
                gameSettings.layout = .two
            }, players: .two)
            
            PlayerLayout(isSelected: gameSettings.layout == .threeLeft, onClick: {
                gameSettings.layout = .threeLeft
            }, players: .threeLeft)
            
            PlayerLayout(isSelected: gameSettings.layout == .threeRight, onClick: {
                gameSettings.layout = .threeRight
            }, players: .threeRight)
            
            PlayerLayout(isSelected: gameSettings.layout == .four, onClick: {
                gameSettings.layout = .four
            }, players: .four)
            
            PlayerLayout(isSelected: gameSettings.layout == .five, onClick: {
                gameSettings.layout = .five
            }, players: .five)
            
            PlayerLayout(isSelected: gameSettings.layout == .six, onClick: {
                gameSettings.layout = .six
            }, players: .six)
        }
    }
    
    // MARK: - Helper Functions
    
    private func handleSettingsChange(previousLayout: PlayerLayouts) {
        showingResetAlert = true
        self.previousLayout = previousLayout
    }
    
    // MARK: - Adaptive Properties
    
    // Panel dimensions
    private var settingsPanelWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        // iPad: 1/3 of screen, iPhone: 80% of screen
        return isIPad ? screenWidth / 3 : screenWidth * 0.8
    }
    
    private var settingsPanelHeight: CGFloat {
        // Used for iPhone in landscape
        return UIScreen.main.bounds.height * 0.7
    }
    
    // Grid properties
    private var adaptiveGridColumns: Int {
        // Since we're always in landscape, use 3 columns for iPad and landscape iPhone
        return isIPad ? 3 : 3
    }
    
    private var adaptiveGridSpacing: CGFloat {
        isIPad ? 16 : 8
    }
    
    // Text sizes
    private var adaptiveTitleSize: CGFloat {
        isIPad ? 36 : 24 // Always landscape
    }
    
    private var adaptiveSubtitleSize: CGFloat {
        isIPad ? 28 : 20 // Always landscape
    }
    
    // Spacing
    private var adaptiveSpacing: CGFloat {
        isIPad ? 24 : 16
    }
    
    // Button/Icon sizes
    private var adaptiveIconSize: CGFloat {
        isIPad ? 30 : 24
    }
    
    private var adaptiveButtonPadding: CGFloat {
        isIPad ? 16 : 12
    }
    
    // Padding
    private var adaptivePadding: EdgeInsets {
        if isIPad {
            return EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        } else {
            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        }
    }
}

#Preview {
    Group {
        // iPhone Portrait
//        GameView()
//            .environmentObject(GameSettings())
//            .environmentObject(PlayerState())
//            .previewDevice("iPhone 14")
//            .previewDisplayName("iPhone Portrait")
//
//        // iPhone Landscape
//        GameView()
//            .environmentObject(GameSettings())
//            .environmentObject(PlayerState())
//            .previewDevice("iPhone 14")
//            .previewInterfaceOrientation(.landscapeLeft)
//            .previewDisplayName("iPhone Landscape")
//        
//        // iPad Portrait
//        GameView()
//            .environmentObject(GameSettings())
//            .environmentObject(PlayerState())
//            .previewDevice("iPad Pro (11-inch)")
//            .environment(\.horizontalSizeClass, .regular)
//            .environment(\.verticalSizeClass, .regular)
//            .previewDisplayName("iPad Portrait")

        // iPad Landscape
        GameView()
            .environmentObject(GameSettings())
            .environmentObject(PlayerState())
            .previewDevice("iPad Pro (11-inch)")
            .environment(\.horizontalSizeClass, .regular)
            .environment(\.verticalSizeClass, .regular)
            .previewInterfaceOrientation(.landscapeLeft)
            .previewDisplayName("iPad Landscape")
    }
}
