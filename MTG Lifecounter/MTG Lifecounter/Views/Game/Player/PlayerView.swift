//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI
import UIKit

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
    @State private var showOverlay = false
    @State private var dragDistance: CGFloat = 0
    @State private var overlayOpacity: Double = 0
    
    // Minimum distance to trigger the overlay
    private let minDragDistance: CGFloat = 80
    
    var body: some View {
        ZStack {
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
                            .onTapGesture {
                                showEditSheet = true
                            }
                        Spacer()
                    }
                    .padding(.top, 12)
                    
                    // Two-finger gesture recognizer indicator (visual hint)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Image(systemName: "hand.draw.fill")
                                .font(.system(size: 20))
                                .opacity(0.5)
                                .foregroundColor(DEFAULT_STYLES.foreground)
                                .padding(8)
                        }
                        .padding(.trailing, 12)
                        .padding(.bottom, 12)
                    }
                }
            )
            .rotationEffect((orientation.toAngle()))
            .overlay(
                TwoFingerSwipeGesture(direction: .up) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showOverlay = true
                    }
                }
            )
            
            // Player tools overlay
            if showOverlay {
                PlayerToolsOverlay(onDismiss: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        showOverlay = false
                    }
                })
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // We're now using the custom two-finger gesture recognizer instead of showing preview overlay
        }
        .sheet(isPresented: $showEditSheet) {
            EditPlayerView(player: $player)
        }
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
    @State private var showOverlay = false
    @State private var showEditSheet = false
    @State private var dragDistance: CGFloat = 0
    @State private var overlayOpacity: Double = 0

    let updatePoints: (Side, Int) -> Void
    let startHoldTimer: (Side, Int) -> Void
    let stopHoldTimer: () -> Void
    var orientation: OrientationLayout
    
    // Minimum distance to trigger the overlay
    private let minDragDistance: CGFloat = 80
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                                .onTapGesture {
                                    showEditSheet.toggle()
                                }
                            Spacer()
                        }
                        
                        // Two-finger gesture recognizer indicator (visual hint)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "hand.draw.fill")
                                    .font(.system(size: 20))
                                    .opacity(0.5)
                                    .foregroundColor(DEFAULT_STYLES.foreground)
                                    .padding(8)
                            }
                            .padding(.trailing, 12)
                            .padding(.bottom, 12)
                        }
                    }
                )
                // Two-finger swipe gesture
                .overlay(
                    TwoFingerSwipeGesture(direction: .up) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showOverlay = true
                        }
                    }
                )
                
                // Player tools overlay
                if showOverlay {
                    PlayerToolsOverlay(onDismiss: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            showOverlay = false
                        }
                    })
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                
                // We're now using the custom two-finger gesture recognizer instead of showing preview overlay
            }
            .sheet(isPresented: $showEditSheet) {
                EditPlayerView(player: $player)
            }
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

// Enhanced player tools overlay
struct PlayerToolsOverlay: View {
    var onDismiss: () -> Void
    @State private var toolItems = [
        ToolItem(id: 0, iconName: "dice", label: "Roll D20", description: "Random 1-20"),
        ToolItem(id: 1, iconName: "die.face.6", label: "Roll D6", description: "Random 1-6"),
        ToolItem(id: 2, iconName: "die.face.4.fill", label: "Roll D4", description: "Random 1-4"),
        ToolItem(id: 3, iconName: "counter", label: "Counter", description: "Add token")
    ]
    @State private var selectedTool: ToolItem?
    @State private var isPresentingTool = false
    @State private var diceResult: Int?
    @State private var isRollingDice = false
    @State private var counter: Int = 0
    @State private var animateAppear = false
    
    var body: some View {
        ZStack {
            // Semi-transparent background with blur
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissWithAnimation()
                }
            
            VStack(spacing: 0) {
                // Pull indicator
                RoundedRectangle(cornerRadius: 2.5)
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.6))
                    .padding(.top, 12)
                    .padding(.bottom, 8)
                
                // Tools title
                Text("Tools")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                
                // Tools grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                ], spacing: 20) {
                    ForEach(toolItems) { item in
                        OverlayButton(
                            iconName: item.iconName,
                            label: item.label,
                            action: {
                                selectedTool = item
                                isPresentingTool = true
                                
                                // Handle different tool actions
                                switch item.id {
                                case 0: // D20
                                    rollDice(sides: 20)
                                case 1: // D6
                                    rollDice(sides: 6)
                                case 2: // D4
                                    rollDice(sides: 4)
                                case 3: // Counter
                                    counter += 1
                                default:
                                    break
                                }
                            }
                        )
                        .scaleEffect(animateAppear ? 1.0 : 0.8)
                        .opacity(animateAppear ? 1.0 : 0.0)
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.6)
                            .delay(Double(item.id) * 0.05),
                            value: animateAppear
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Results display
                if diceResult != nil || counter > 0 {
                    VStack(spacing: 8) {
                        if let result = diceResult {
                            HStack(spacing: 16) {
                                Text("Result:")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text("\(result)")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .frame(width: 60, height: 60)
                                    .background(
                                        Circle()
                                            .fill(Color(hex: "4a6d88"))
                                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                    )
                                    .scaleEffect(isRollingDice ? 1.1 : 1.0)
                                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isRollingDice)
                            }
                        }
                        
                        if counter > 0 {
                            HStack(spacing: 16) {
                                Text("Counter:")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                HStack {
                                    Button(action: {
                                        if counter > 0 {
                                            counter -= 1
                                        }
                                    }) {
                                        Image(systemName: "minus.circle")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }
                                    
                                    Text("\(counter)")
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(minWidth: 40)
                                        .padding(.horizontal, 4)
                                    
                                    Button(action: {
                                        counter += 1
                                    }) {
                                        Image(systemName: "plus.circle")
                                            .font(.system(size: 22))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(hex: "4a6d88"))
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.opacity)
                    .animation(.easeInOut, value: diceResult)
                    .animation(.easeInOut, value: counter)
                }
                
                // Action buttons
                HStack(spacing: 10) {
                    // Reset button
                    if diceResult != nil || counter > 0 {
                        Button(action: {
                            diceResult = nil
                            counter = 0
                        }) {
                            Text("Reset")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color(hex: "555555"))
                                .cornerRadius(10)
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: diceResult)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: counter)
                    }
                    
                    // Close button
                    Button(action: {
                        dismissWithAnimation()
                    }) {
                        Text("Close")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(hex: "4a6d88"))
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .opacity(animateAppear ? 1.0 : 0.0)
                .offset(y: animateAppear ? 0 : 20)
                .animation(.easeOut(duration: 0.3).delay(0.2), value: animateAppear)
            }
            .background(
                Color(hex: "2A3D4F")
                    .opacity(0.97)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            )
            .frame(maxWidth: 300)
            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 5)
            .offset(y: animateAppear ? 0 : 50)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                animateAppear = true
            }
        }
    }
    
    private func dismissWithAnimation() {
        withAnimation(.easeIn(duration: 0.2)) {
            animateAppear = false
        }
        
        // Delay the actual dismissal until animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
    
    private func rollDice(sides: Int) {
        isRollingDice = true
        
        // Generate multiple random numbers quickly to simulate rolling animation
        var rollCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            diceResult = Int.random(in: 1...sides)
            rollCount += 1
            
            if rollCount >= 10 { // Roll animation for 1 second
                timer.invalidate()
                isRollingDice = false
            }
        }
    }
}

// Model for tool items
struct ToolItem: Identifiable {
    let id: Int
    let iconName: String
    let label: String
    let description: String
}

// Enhanced overlay button with label
struct OverlayButton: View {
    let iconName: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(
                        LinearGradient(
                            colors: [Color(hex: "4a6d88"), Color(hex: "375165")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                
                Text(label)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
        .buttonStyle(
            ScaleButtonStyle()
        )
    }
}

// Custom button style with scale effect
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Drag Direction Helper

enum DragDirection {
    case up, down, left, right, none
}

extension DragGesture.Value {
    var dragDirection: DragDirection {
        let horizontalAmount = abs(translation.width)
        let verticalAmount = abs(translation.height)
        
        if horizontalAmount > verticalAmount {
            return translation.width < 0 ? .left : .right
        } else if verticalAmount > horizontalAmount {
            return translation.height < 0 ? .up : .down
        }
        
        return .none
    }
}

//#Preview{
//    PlayerView(player: .constant(Player(HP: 40, name: "Vinicius" )), orientation: .normal)
//}

#Preview{
    PlayerToolsOverlay(onDismiss: {})
}
