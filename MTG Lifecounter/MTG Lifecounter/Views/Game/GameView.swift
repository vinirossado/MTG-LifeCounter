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
    @State private var orientationManager = DeviceOrientationManager.shared
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var isLandscape: Bool {
        orientationManager.isLandscape
    }
    
    private var settingsButtonPosition: Edge {
        if orientationManager.isPad {
            return .trailing
        } else {
            return orientationManager.isLandscape ? .bottom : .trailing
        }
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
                orientationManager.updateOrientation(size: geometry.size)
            }
            .onChange(of: geometry.size) { oldSize, newSize in
                orientationManager.updateOrientation(size: newSize)
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
                        gameSettings.layout = prevLayout // Revert to the previous layout
                    }
                }
            } message: {
                Text("Do you want to reset the game?")
            }
        }
        .ignoresSafeArea(.keyboard) // Better keyboard handling
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
                    if orientationManager.isPad || !orientationManager.isLandscape {
                        // iPad or iPhone portrait - show from side
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
        return orientationManager.isPad ? screenWidth / 3 : screenWidth * 0.8
    }
    
    private var settingsPanelHeight: CGFloat {
        // Used for iPhone in landscape
        return UIScreen.main.bounds.height * 0.7
    }
    
    // Grid properties
    private var adaptiveGridColumns: Int {
        // 3 columns on iPad/larger screens, 2 on small screens in landscape
        if orientationManager.isPad {
            return 3
        } else if orientationManager.isLandscape {
            return 3
        } else {
            return 2
        }
    }
    
    private var adaptiveGridSpacing: CGFloat {
        orientationManager.isPad ? 16 : 8
    }
    
    // Text sizes
    private var adaptiveTitleSize: CGFloat {
        orientationManager.isPad ? 36 : (orientationManager.isLandscape ? 24 : 30)
    }
    
    private var adaptiveSubtitleSize: CGFloat {
        orientationManager.isPad ? 28 : (orientationManager.isLandscape ? 20 : 24)
    }
    
    // Spacing
    private var adaptiveSpacing: CGFloat {
        orientationManager.isPad ? 24 : 16
    }
    
    // Button/Icon sizes
    private var adaptiveIconSize: CGFloat {
        orientationManager.isPad ? 30 : 24
    }
    
    private var adaptiveButtonPadding: CGFloat {
        orientationManager.isPad ? 16 : 12
    }
    
    // Padding
    private var adaptivePadding: EdgeInsets {
        if orientationManager.isPad {
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
