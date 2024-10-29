import SwiftUI

// MARK: - Models
struct Player: Identifiable {
    let id = UUID()
    var HP: Int
    var name: String
}

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
    static func buildLayout(for players: [Binding<Player>]) -> some View {
        guard let layout = GameLayout.from(playerCount: players.count) else {
            return AnyView(EmptyView())
        }
        
        switch layout {
        case .twoPlayers:
            return AnyView(TwoPlayersLayout(players: players))
        case .threePlayers:
            return AnyView(ThreePlayersLayout(players: players))
        case .fourPlayers:
            return AnyView(FourPlayersLayout(players: players))
        case .fivePlayers:
            return AnyView(FivePlayersLayout(players: players))
        case .sixPlayers:
            return AnyView(SixPlayersLayout(players: players))
        }
    }
}

// MARK: - Layout Views
struct TwoPlayersLayout: View {
    let players: [Binding<Player>]
    
    var body: some View {
        HStack(spacing: 10) {
            PlayerView(player: players[0], orientation: .right)
            PlayerView(player: players[1], orientation: .left)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ThreePlayersLayout: View {
    let players: [Binding<Player>]
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 10) {
                PlayerView(player: players[0], orientation: .inverted)
                PlayerView(player: players[2], orientation: .normal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            PlayerView(player: players[1], orientation: .left)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct FourPlayersLayout: View {
    let players: [Binding<Player>]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                PlayerView(player: players[0], orientation: .inverted)
                PlayerView(player: players[1], orientation: .inverted)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 10) {
                PlayerView(player: players[2], orientation: .normal)
                PlayerView(player: players[3], orientation: .normal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct FivePlayersLayout: View {
    let players: [Binding<Player>]
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 10) {
                PlayerView(player: players[0], orientation: .inverted)
                PlayerView(player: players[2], orientation: .normal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            VStack(spacing: 10) {
                PlayerView(player: players[1], orientation: .inverted)
                PlayerView(player: players[3], orientation: .normal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            PlayerView(player: players[4], orientation: .left)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct SixPlayersLayout: View {
    let players: [Binding<Player>]
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                PlayerView(player: players[0], orientation: .inverted)
                PlayerView(player: players[1], orientation: .inverted)
                PlayerView(player: players[2], orientation: .inverted)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            HStack(spacing: 10) {
                PlayerView(player: players[3], orientation: .normal)
                PlayerView(player: players[4], orientation: .normal)
                PlayerView(player: players[5], orientation: .normal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Main View
struct GameView: View {
    @State private var players: [Player] = (1...6).map { idx in
        Player(HP: 40, name: "Player \(idx)")
    }
    
    var body: some View {
        GeometryReader { geometry in
            GameLayoutBuilder.buildLayout(for: players.indices.map { $players[$0] })
        }
        .navigationBarHidden(true)
        .ignoresSafeArea() 
    }
}

#Preview {
    GameView()
}
