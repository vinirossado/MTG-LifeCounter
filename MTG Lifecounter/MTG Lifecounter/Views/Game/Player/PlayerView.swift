//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif

enum Side {
    case left, right
}

struct Style {
    var background: Color
    var foreground: Color
    var opacity: Double
    var hoverOpacity: Double
}

enum OrientationLayout {
    case normal
    case inverted
    case left
    case right
    
    func toAngle() -> Angle {
        switch self {
        case .normal: return Angle(degrees: 0)
        case .right: return Angle(degrees: 90)
        case .inverted: return Angle(degrees: 180)
        case .left: return Angle(degrees: 270)
        }
    }
}

let DEFAULT_STYLES = Style(
    background: .oceanBlueBackground,
    foreground: .lightGrayText,
    opacity: 1,
    hoverOpacity: 0.75
)

struct PlayerView: View {
    @Binding var player: Player
    var orientation: OrientationLayout
    @State private var isLeftPressed: Bool = false
    @State private var isRightPressed: Bool = false
    @State private var cumulativeChange: Int = 0
    @State private var showChange: Bool = false
    @State private var holdTimer: Timer?
    @State private var isHoldTimerActive: Bool = false
    @State private var changeWorkItem: DispatchWorkItem?

    
    var body: some View {
        orientation == .normal || orientation == .inverted
        ? AnyView(
            HorizontalPlayerView(
                player: $player,
                isLeftPressed: $isLeftPressed,
                isRightPressed: $isRightPressed,
                cumulativeChange: $cumulativeChange,
                showChange: $showChange,
                holdTimer: $holdTimer,
                isHoldTimerActive: $isHoldTimerActive,
                changeWorkItem: $changeWorkItem,
                updatePoints: updatePoints,
                startHoldTimer: startHoldTimer,
                stopHoldTimer: stopHoldTimer,
                orientation: orientation
            )
        )
        : AnyView(
            VerticalPlayerView(
                player: $player,
                isLeftPressed: $isLeftPressed,
                isRightPressed: $isRightPressed,
                cumulativeChange: $cumulativeChange,
                showChange: $showChange,
                holdTimer: $holdTimer,
                isHoldTimerActive: $isHoldTimerActive,
                changeWorkItem: $changeWorkItem,
                updatePoints: updatePoints,
                startHoldTimer: startHoldTimer,
                stopHoldTimer: stopHoldTimer,
                orientation: orientation
            )
        )
    }
    
    private func updatePoints(for side: Side, amount: Int) {
        switch side {
        case .left:
            player.HP -= amount
            cumulativeChange -= amount
        case .right:
            player.HP += amount
            cumulativeChange += amount
        }
        
        showPointChange()
    }
    
    private func startHoldTimer(for side: Side, amount: Int) {
        guard !isHoldTimerActive else {
            return
        }
        
        isHoldTimerActive = true
        
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            updatePoints(for: side, amount: amount)
        }
    }
    
    private func stopHoldTimer() {
        holdTimer?.invalidate()
        holdTimer = nil
        isHoldTimerActive = false
    }
    
    private func showPointChange() {
        changeWorkItem?.cancel()        
        showChange = true
        
        let newWorkItem = DispatchWorkItem {
            showChange = false
            cumulativeChange = 0
        }
        
        changeWorkItem = newWorkItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: newWorkItem)
    }
}

struct HorizontalPlayerView: View {
    @Binding var player: Player
    @Binding var isLeftPressed: Bool
    @Binding var isRightPressed: Bool
    @Binding var cumulativeChange: Int
    @Binding var showChange: Bool
    @Binding var holdTimer: Timer?
    @Binding var isHoldTimerActive: Bool
    @Binding var changeWorkItem: DispatchWorkItem?
    let updatePoints: (Side, Int) -> Void
    let startHoldTimer: (Side, Int) -> Void
    let stopHoldTimer: () -> Void
    var orientation: OrientationLayout
    @State private var showEditSheet = false

    
    var body: some View {
        HStack(spacing: 0) {
            PressableRectangle(
                isPressed: $isLeftPressed,
                player: $player,
                side: .left,
                updatePoints: updatePoints,
                startHoldTimer: startHoldTimer,
                stopHoldTimer: stopHoldTimer
            )
            
            PressableRectangle(
                isPressed: $isRightPressed,
                player: $player,
                side: .right,
                updatePoints: updatePoints,
                startHoldTimer: startHoldTimer,
                stopHoldTimer: stopHoldTimer
            )
        }
        
        .cornerRadius(16)
        .foregroundColor(.white)
        .overlay(
            ZStack {
                Text("\(player.HP)")
                    .font(.system(size: 48))
                
                HStack {
                    Image(systemName: "minus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                    Spacer()
                }
                .padding(.leading, 32)
                
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                }
                .padding(.trailing, 32)
                
                if cumulativeChange != 0 {
                    Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                        .font(.system(size: 24))
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .offset(x: cumulativeChange > 0 ? 60 : -60)
                        .opacity(showChange ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showChange)
                }
                
                VStack {
                    Text(player.name )
                        .font(.system(size: 24))
                        .foregroundColor(DEFAULT_STYLES.foreground)
                    Spacer()
                }
                 .onTapGesture {
                     showEditSheet = true
                 }
                 .sheet(isPresented: $showEditSheet) {
                     EditPlayerView(player: $player)
                 }
                .padding(.top, 12)
            }
        ).rotationEffect((orientation.toAngle()))
    }
}

struct VerticalPlayerView: View {
    @Binding var player: Player
    @Binding var isLeftPressed: Bool
    @Binding var isRightPressed: Bool
    @Binding var cumulativeChange: Int
    @Binding var showChange: Bool
    @Binding var holdTimer: Timer?
    @Binding var isHoldTimerActive: Bool
    @Binding var changeWorkItem: DispatchWorkItem?
    @State private var showOverlay = true
    @State private var showEditSheet = false

    let updatePoints: (Side, Int) -> Void
    let startHoldTimer: (Side, Int) -> Void
    let stopHoldTimer: () -> Void
    var orientation: OrientationLayout
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                PressableRectangle(
                    isPressed: $isLeftPressed,
                    player: $player,
                    side: .right,
                    updatePoints: updatePoints,
                    startHoldTimer: startHoldTimer,
                    stopHoldTimer: stopHoldTimer
                )
                
                PressableRectangle(
                    isPressed: $isRightPressed,
                    player: $player,
                    side: .left,
                    updatePoints: updatePoints,
                    startHoldTimer: startHoldTimer,
                    stopHoldTimer: stopHoldTimer
                )
            }
            .cornerRadius(16)
            .foregroundColor(.white)
            .overlay(
                ZStack {
                    Text("\(player.HP)")
                        .font(.system(size: 48))
                        .rotationEffect(Angle(degrees: 270))
                    
                    VStack {
                        Image(systemName: "minus")
                            .foregroundColor(DEFAULT_STYLES.foreground)
                            .font(.system(size: 24))
                            .rotationEffect(Angle(degrees: 90))
                            .padding(.bottom, 64)
                    }
                    .frame(height: geometry.size.height, alignment: .bottom)
                    
                    VStack {
                        Image(systemName: "plus")
                            .foregroundColor(DEFAULT_STYLES.foreground)
                            .font(.system(size: 24))
                            .padding(.top, 64)
                    }
                    .frame(height: geometry.size.height, alignment: .top)
                    
                    if cumulativeChange != 0 {
                        Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                            .font(.system(size: 24))
                            .foregroundColor(DEFAULT_STYLES.foreground)
                            .offset(x: cumulativeChange > 0 ? 60 : -60)
                            .opacity(showChange ? 1 : 0)
                            .rotationEffect(Angle(degrees: 270))
                    }
                    
                    HStack {
                        Text(player.name)
                            .font(.system(size: 24))
                            .foregroundColor(DEFAULT_STYLES.foreground)
                            .rotationEffect(Angle(degrees: 270))
                        Spacer()
                    }
                    
                }
            )
            if showOverlay {
                PlayerToolsOverlay(onDismiss: {
                    showOverlay.toggle()
                })
                .animation(.easeInOut, value: showOverlay)
            }
            
            VStack {
                Text(player.name)
                    .font(.system(size: 24))
                    .foregroundColor(DEFAULT_STYLES.foreground)
                    .onTapGesture {
                        // Add sheet for editing player name similar to HorizontalPlayerView
                        showEditSheet.toggle()
                    }
                
                Button(action: {
                    showOverlay.toggle()
                }) {
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 24))
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .padding()
                        .background(Color(hex: "4a6d88"))
                        .cornerRadius(10)
                }
            }
            .sheet(isPresented: $showEditSheet) {
                EditPlayerView(player: $player)
            }
        }
        // The second overlay is redundant and causing the geometry scope issue
        // We already have all the UI elements in the first overlay
    }
}


struct PressableRectangle: View {
    @Binding var isPressed: Bool  
    @Binding var player: Player
    var side: Side
    var updatePoints: (Side, Int) -> Void
    var startHoldTimer: (Side, Int) -> Void
    var stopHoldTimer: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(DEFAULT_STYLES.background)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .opacity(isPressed ? DEFAULT_STYLES.hoverOpacity : DEFAULT_STYLES.opacity)
            .onTapGesture {
                updatePoints(side, 1)
            }
            .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 0.4, pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
                
                if pressing {
                    startHoldTimer(side, 10)
                } else {
                    stopHoldTimer()
                }
                
            }, perform: {})
    }
}

struct NameView: View {
    let name: String;
    
    var body: some View {
        VStack {
            Text("\(name)")
        }
    }
}

// Simplified overlay view for better performance
struct PlayerToolsOverlay: View {
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            // Simple semi-transparent background
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            HStack(spacing: 16) {
                VStack(spacing: 16) {
                    OverlayButton(iconName: "die.face.4.fill", action: {
                        print("Card 1")
                    })
                    
                    OverlayButton(iconName: "die.face.5.fill", action: {
                        print("Dice 1")
                    })
                  
                }
                
                VStack(spacing: 16) {
                    OverlayButton(iconName: "die.face.4.fill", action: {
                        print("Card 2")
                    })
                    
                    OverlayButton(iconName: "die.face.6.fill", action: {
                        print("Dice 2")
                    })
                }
                
               
            }
            .padding(16)
            .background(Color(hex: "2A3D4F"))
            .cornerRadius(12)
        }
        .transition(.opacity)
    }
}

// Simplified button component for better performance
struct OverlayButton: View {
    let iconName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
                .background(Color(hex: "4a6d88"))
                .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//#Preview{
//    PlayerView(player: .constant(Player(HP: 40, name: "Vinicius" )), orientation: .normal)
//}

#Preview{
    PlayerToolsOverlay(onDismiss: {})
}
