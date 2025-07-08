//
//  MTGHorizontalPlayerComponent.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 8.07.2025.
//

import SwiftUI

// MARK: - Player Name Position Helper
struct PlayerNamePosition {
    let isTop: Bool
    let rotation: Angle
}

// MARK: - MTG Horizontal Player Component
struct MTGHorizontalPlayerComponent: View {
    // MARK: - Properties
    @Binding var player: Player
    @Binding var isLeftPressed: Bool
    @Binding var isRightPressed: Bool
    @Binding var cumulativeChange: Int
    @Binding var showChange: Bool
    @Binding var holdTimer: Timer?
    @Binding var isHoldTimerActive: Bool
    @Binding var changeWorkItem: DispatchWorkItem?
    
    let allPlayers: [Player]
    let updatePoints: (SideEnum, Int) -> Void
    let startHoldTimer: (SideEnum, Int) -> Void
    let stopHoldTimer: () -> Void
    let orientation: OrientationLayout
    
    @State private var showEditSheet = false
    @State private var showOverlay = false
    
    // Services
    private let lifeService = PlayerLifeService()
    
    // MARK: - Computed Properties
    private var namePosition: PlayerNamePosition {
        switch orientation {
        case .normal:
            return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 0))
        case .inverted:
            return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 180))
        case .left:
            return PlayerNamePosition(isTop: false, rotation: Angle(degrees: 270))
        case .right:
            return PlayerNamePosition(isTop: true, rotation: Angle(degrees: 90))
        }
    }
    
    private var activeIndicators: [MTGIndicatorItem] {
        MTGIndicatorFactory.createIndicators(for: player, allPlayers: allPlayers)
    }
    
    // MARK: - Body
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Commander artwork background
                commanderArtworkBackground(geometry: geometry)
                
                // Player interaction areas
                playerInteractionAreas
                
                // Main overlay with content
                playerContentOverlay(geometry: geometry)
                
                // Player tools overlay
                if showOverlay {
                    PlayerToolsOverlay(
                        player: $player,
                        allPlayers: allPlayers,
                        playerOrientation: orientation,
                        onDismiss: {
                            withAnimation(MTGAnimation.standardSpring) {
                                showOverlay = false
                            }
                        }
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .clipped()
            .sheet(isPresented: $showEditSheet) {
                EditPlayerView(player: $player, playerOrientation: orientation)
            }
        }
    }
    
    // MARK: - View Builders
    
    @ViewBuilder
    private func commanderArtworkBackground(geometry: GeometryProxy) -> some View {
        if player.useCommanderAsBackground,
           let artworkURL = player.commanderArtworkURL ?? player.commanderImageURL {
            AsyncImage(url: URL(string: artworkURL)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                        .opacity(0.4)
                        .blur(radius: 1)
                        .rotationEffect(orientation.toAngle())
                case .failure(_), .empty:
                    Color.clear
                @unknown default:
                    Color.clear
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .cornerRadius(MTGCornerRadius.lg)
        }
    }
    
    private var playerInteractionAreas: some View {
        HStack(spacing: 1) {
            MTGPressableButton(
                isPressed: $isLeftPressed,
                side: .left,
                onTap: { updatePoints(.left, 1) },
                onLongPress: { pressing in
                    if pressing {
                        startHoldTimer(.left, 10)
                    } else {
                        stopHoldTimer()
                    }
                }
            )
            
            MTGPressableButton(
                isPressed: $isRightPressed,
                side: .right,
                onTap: { updatePoints(.right, 1) },
                onLongPress: { pressing in
                    if pressing {
                        startHoldTimer(.right, 10)
                    } else {
                        stopHoldTimer()
                    }
                }
            )
        }
        .cornerRadius(MTGCornerRadius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: MTGCornerRadius.lg)
                .stroke(Color.MTG.textPrimary.opacity(0.4), lineWidth: 3)
        )
        .rotationEffect(orientation.toAngle())
        .gesture(swipeGesture)
    }
    
    @ViewBuilder
    private func playerContentOverlay(geometry: GeometryProxy) -> some View {
        ZStack {
            // Main HP display
            lifePointsDisplay
            
            // Interaction icons
            interactionIcons
            
            // Change indicator
            if cumulativeChange != 0 {
                changeIndicator
            }
            
            // Player name
            playerNameView(geometry: geometry)
            
            // Status indicators
            statusIndicators
        }
    }
    
    private var lifePointsDisplay: some View {
        Text("\(player.HP)")
            .font(.system(size: 48, weight: .bold))
            .foregroundColor(Color.MTG.textPrimary)
            .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 0)
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 0)
            .rotationEffect(namePosition.rotation)
    }
    
    private var interactionIcons: some View {
        VStack {
            Spacer()
            HStack {
                // Minus icon (left side)
                Image(systemName: "minus")
                    .foregroundColor(Color.MTG.textPrimary)
                    .font(.system(size: 24, weight: .medium))
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 0)
                    .rotationEffect(namePosition.rotation)
                    .padding(.leading, MTGSpacing.xl)
                
                Spacer()
                
                // Plus icon (right side)
                Image(systemName: "plus")
                    .foregroundColor(Color.MTG.textPrimary)
                    .font(.system(size: 24, weight: .medium))
                    .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 0)
                    .rotationEffect(namePosition.rotation)
                    .padding(.trailing, MTGSpacing.xl)
            }
            Spacer()
        }
    }
    
    private var changeIndicator: some View {
        Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(cumulativeChange > 0 ? Color.MTG.success : Color.MTG.error)
            .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 0)
            .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 0)
            .offset(x: cumulativeChange > 0 ? 60 : -60)
            .opacity(showChange ? 1 : 0)
            .rotationEffect(namePosition.rotation)
            .animation(MTGAnimation.medium, value: showChange)
    }
    
    @ViewBuilder
    private func playerNameView(geometry: GeometryProxy) -> some View {
        VStack {
            if namePosition.isTop {
                HStack {
                    Spacer()
                    playerNameText(geometry: geometry)
                        .padding(.top, MTGSpacing.sm)
                    Spacer()
                }
                Spacer()
            } else {
                Spacer()
                HStack {
                    Spacer()
                    playerNameText(geometry: geometry)
                        .padding(.bottom, MTGSpacing.sm)
                    Spacer()
                }
            }
        }
    }
    
    private func playerNameText(geometry: GeometryProxy) -> some View {
        Text(player.name)
            .font(.system(
                size: min(max(geometry.size.width * 0.05, 14), 20),
                weight: .semibold,
                design: .rounded
            ))
            .foregroundColor(Color.MTG.textPrimary)
            .padding(.horizontal, MTGSpacing.sm)
            .padding(.vertical, MTGSpacing.xs)
            .background(
                RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
                    .fill(Color.MTG.deepBlack.opacity(0.25))
                    .overlay(
                        RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
                            .stroke(Color.MTG.textPrimary.opacity(0.15), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.15), radius: 1, x: 0, y: 1)
            .rotationEffect(namePosition.rotation)
            .scaleEffect(showEditSheet ? 1.05 : 1.0)
            .animation(MTGAnimation.standardSpring, value: showEditSheet)
            .onTapGesture {
                withAnimation(MTGAnimation.standardSpring) {
                    showEditSheet.toggle()
                }
            }
    }
    
    @ViewBuilder
    private var statusIndicators: some View {
        VStack {
            if namePosition.isTop {
                Spacer()
                MTGIndicatorRow(indicators: activeIndicators, orientation: orientation)
                    .padding(.bottom, MTGSpacing.sm)
            } else {
                MTGIndicatorRow(indicators: activeIndicators, orientation: orientation)
                    .padding(.top, MTGSpacing.sm)
                Spacer()
            }
        }
    }
    
    // MARK: - Gesture Handling
    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded { value in
                print("🛠️ MTGHorizontalPlayerComponent: Swipe gesture detected for Tools")
                
                let distance = sqrt(value.translation.width * value.translation.width + value.translation.height * value.translation.height)
                
                if distance > 50 {
                    print("✅ MTGHorizontalPlayerComponent: Opening Tools overlay")
                    withAnimation(MTGAnimation.standardSpring) {
                        showOverlay = true
                    }
                }
            }
    }
}

// MARK: - Preview
#Preview("MTG Horizontal Player Component") {
    MTGHorizontalPlayerComponent(
        player: .constant(Player(HP: 20, name: "Player 1")),
        isLeftPressed: .constant(false),
        isRightPressed: .constant(false),
        cumulativeChange: .constant(0),
        showChange: .constant(false),
        holdTimer: .constant(nil),
        isHoldTimerActive: .constant(false),
        changeWorkItem: .constant(nil),
        allPlayers: [
            Player(HP: 20, name: "Player 1"),
            Player(HP: 20, name: "Player 2"),
            Player(HP: 20, name: "Player 3"),
            Player(HP: 20, name: "Player 4")
        ],
        updatePoints: { _, _ in },
        startHoldTimer: { _, _ in },
        stopHoldTimer: { },
        orientation: .normal
    )
    .frame(width: 300, height: 200)
    .background(Color.MTG.deepBlack)
}
