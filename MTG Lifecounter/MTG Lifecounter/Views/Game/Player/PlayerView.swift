//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.10.2024.
//

import SwiftUI


struct Style {
    var background: Color
    var foreground: Color
    var opacity: Double
    var hoverOpacity: Double
}

let DEFAULT_STYLES = Style(
    background: Color.mint.opacity(0.8),
    foreground: Color.white,
    opacity: 1,
    hoverOpacity: 0.75
)

struct PlayerView: View {
    @Binding var playerHP: Int
    @State private var isLeftPressed: Bool = false
    @State private var isRightPressed: Bool = false
    @State private var cumulativeChange: Int = 0
    @State private var showChange: Bool = false
    @State private var holdTimer: Timer?
    @State private var changeWorkItem: DispatchWorkItem?
    
    enum Side {
        case left, right
    }
    
    var body: some View {
        HStack(spacing: 0) {
            PressableRectangle(
                isPressed: $isLeftPressed,
                side: .left,
                updatePoints: updatePoints,
                startHoldTimer: startHoldTimer,
                stopHoldTimer: stopHoldTimer
            )
            
            PressableRectangle(
                isPressed: $isRightPressed,
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
                Text("\(playerHP)")
                    .font(.system(size: 48))
                
                HStack {
                    Image(systemName: "minus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                    Spacer()
                }
                .padding(.leading, 16)
                
                HStack {
                    Spacer()
                    Image(systemName: "plus")
                        .foregroundColor(DEFAULT_STYLES.foreground)
                        .font(.system(size: 24))
                }
                .padding(.trailing, 16)
                
                if cumulativeChange != 0 {
                    Text(cumulativeChange > 0 ? "+\(cumulativeChange)" : "\(cumulativeChange)")
                        .font(.system(size: 24))
                        .foregroundColor(cumulativeChange > 0 ? .green : .red)
                        .offset(x: cumulativeChange > 0 ? 60 : -60)
                        .opacity(showChange ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: showChange)
                }
            }
        )
    }
    
    private func updatePoints(for side: Side, amount: Int) {
        switch side {
        case .left:
            playerHP -= amount
            cumulativeChange -= amount
        case .right:
            playerHP += amount
            cumulativeChange += amount
        }
        
        showPointChange()
    }
    
    private func startHoldTimer(for side: Side, amount: Int) {
        holdTimer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { _ in
            updatePoints(for: side, amount: amount)
        }
    }
    
    private func stopHoldTimer() {
        holdTimer?.invalidate()
        holdTimer = nil
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
        
        // Schedule the work item to be executed after 2s
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: newWorkItem)
    }
}


struct PressableRectangle: View {
    @Binding var isPressed: Bool
    var side: PlayerView.Side
    var updatePoints: (PlayerView.Side, Int) -> Void
    var startHoldTimer: (PlayerView.Side, Int) -> Void
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

#Preview {
    PlayerView(playerHP: .constant(20))
}