//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI

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
            withAnimation {
                showChange = false
                cumulativeChange = 0
            }
        }
        
        changeWorkItem = newWorkItem
        
        // Schedule the work item to be executed after 4s
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: newWorkItem)
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
                    Text(player.name)
                        .font(.system(size: 24))
                        .foregroundColor(DEFAULT_STYLES.foreground)
                    Spacer()
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
                            .animation(.easeInOut(duration: 0.3), value: showChange)
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
            .rotationEffect((Angle(degrees: orientation == .left ? 0 : 180)))
        }
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
