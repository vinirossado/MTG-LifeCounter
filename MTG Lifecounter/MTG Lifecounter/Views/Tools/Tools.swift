//
//  Tools.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

// Model for tool items
struct ToolItem: Identifiable {
    let id: Int
    let iconName: String
    let label: String
    let description: String
}

// Enhanced player tools overlay
struct PlayerToolsOverlay: View {
    var onDismiss: () -> Void
    @State private var toolItems = [
        ToolItem(id: 0, iconName: "dice", label: "Roll D20", description: "Random 1-20"),
        ToolItem(id: 1, iconName: "die.face.6", label: "Roll D6", description: "Random 1-6"),
        ToolItem(id: 2, iconName: "die.face.4.fill", label: "Roll D4", description: "Random 1-4"),
        ToolItem(id: 3, iconName: "dice", label: "Roll D8", description: "Random 1-8")
    ]
    @State private var selectedTool: ToolItem?
    @State private var isPresentingTool = false
    @State private var diceResult: Int?
    @State private var isRollingDice = false
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
                                switch item.id {
                                case 0:
                                    rollDice(sides: 20)
                                case 1:
                                    rollDice(sides: 6)
                                case 2:
                                    rollDice(sides: 4)
                                case 3:
                                    rollDice(sides: 8)
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
                if diceResult != nil {
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
                        
//                        if counter > 0 {
//                            HStack(spacing: 16) {
//                                Text("Counter:")
//                                    .font(.system(size: 18, weight: .medium))
//                                    .foregroundColor(.white.opacity(0.8))
//                                
//                                HStack {
//                                    Button(action: {
//                                        if counter > 0 {
//                                            counter -= 1
//                                        }
//                                    }) {
//                                        Image(systemName: "minus.circle")
//                                            .font(.system(size: 22))
//                                            .foregroundColor(.white)
//                                    }
//                                    
//                                    Text("\(counter)")
//                                        .font(.system(size: 24, weight: .bold))
//                                        .foregroundColor(.white)
//                                        .frame(minWidth: 40)
//                                        .padding(.horizontal, 4)
//                                    
//                                    Button(action: {
//                                        counter += 1
//                                    }) {
//                                        Image(systemName: "plus.circle")
//                                            .font(.system(size: 22))
//                                            .foregroundColor(.white)
//                                    }
//                                }
//                                .padding(8)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 12)
//                                        .fill(Color(hex: "4a6d88"))
//                                )
//                            }
//                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
                    .transition(.opacity)
                    .animation(.easeInOut, value: diceResult)
//                    .animation(.easeInOut, value: counter)
                }
                
                // Action buttons
//                HStack(spacing: 10) {
//                    // Reset button
//                    if diceResult != nil || counter > 0 {
//                        Button(action: {
//                            diceResult = nil
//                            counter = 0
//                        }) {
//                            Text("Reset")
//                                .font(.system(size: 18, weight: .medium))
//                                .foregroundColor(.white)
//                                .frame(maxWidth: .infinity)
//                                .padding(.vertical, 12)
//                                .background(Color(hex: "555555"))
//                                .cornerRadius(10)
//                        }
//                        .transition(.scale.combined(with: .opacity))
//                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: diceResult)
//                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: counter)
//                    }
//                    
//                    // Close button
//                    Button(action: {
//                        dismissWithAnimation()
//                    }) {
//                        Text("Close")
//                            .font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding(.vertical, 12)
//                            .background(Color(hex: "4a6d88"))
//                            .cornerRadius(10)
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 20)
//                .opacity(animateAppear ? 1.0 : 0.0)
//                .offset(y: animateAppear ? 0 : 20)
//                .animation(.easeOut(duration: 0.3).delay(0.2), value: animateAppear)
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
