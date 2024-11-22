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
    
    var body: some View {
        
        ScrollView(.horizontal) {
            HStack() {
                GeometryReader { geometry in
                    GameLayoutBuilder.buildLayout(layout:gameSettings.layout)
                }
                .navigationBarHidden(true)
//                .ignoresSafeArea()
                .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                
                SettingsView()
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.paging)
        .onAppear {
            playerState.initialize(gameSettings: gameSettings)
        }
        .onChange(of: gameSettings.startingLife) { oldValue, newValue in
            print("Starting Life changed from \(oldValue) to \(newValue)")
            
            playerState.initialize(gameSettings: gameSettings)
        }
        .onChange(of: gameSettings.layout) { oldValue, newValue in
            print("Starting Layout changed from \(oldValue) to \(newValue)")
            
            playerState.initialize(gameSettings: gameSettings)
        }
        
    }
}

#Preview {
    GameView()
        .environmentObject(GameSettings())
        .environmentObject(PlayerState())
}
