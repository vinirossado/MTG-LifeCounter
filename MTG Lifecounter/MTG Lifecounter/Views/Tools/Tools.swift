//
//  Tools.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 13.06.2025.
//

import SwiftUI

// Model for MTG-themed tool items
struct MTGToolItem: Identifiable {
    let id: Int
    let iconName: String
    let label: String
    let description: String
    let magicalEffect: String
}

// Enhanced MTG-themed player tools overlay
struct PlayerToolsOverlay: View {
    var onDismiss: () -> Void
    @State private var toolItems = [
        MTGToolItem(id: 0, iconName: MTGIcons.dice, label: "Roll D20", description: "Chaos Control", magicalEffect: "🎲"),
        MTGToolItem(id: 1, iconName: "die.face.6", label: "Roll D6", description: "Minor Divination", magicalEffect: "✨"),
        MTGToolItem(id: 2, iconName: "die.face.4.fill", label: "Roll D4", description: "Basic Fate", magicalEffect: "⚡"),
        MTGToolItem(id: 3, iconName: "dice", label: "Roll D8", description: "Arcane Insight", magicalEffect: "🔮")
    ]
    @State private var selectedTool: MTGToolItem?
    @State private var isPresentingTool = false
    @State private var diceResult: Int?
    @State private var isRollingDice = false
    @State private var animateAppear = false
    @State private var mysticalGlow = false
    
    var body: some View {
        ZStack {
            // Mystical background with blur
            LinearGradient.MTG.mysticalBackground
                .opacity(0.9)
                .ignoresSafeArea()
                .overlay(
                    VisualEffectBlur(blurStyle: .systemMaterialDark)
                        .ignoresSafeArea()
                )
                .onTapGesture {
                    dismissWithAnimation()
                }
            
            VStack(spacing: MTGSpacing.lg) {
                // Mystical pull indicator
                RoundedRectangle(cornerRadius: MTGCornerRadius.xs)
                    .fill(LinearGradient.MTG.magicalGlow)
                    .frame(width: 40, height: 5)
                    .mtgGlow(color: Color.MTG.glowPrimary, radius: 6)
                    .padding(.top, MTGSpacing.sm)
                
                // Magical tools header
                VStack(spacing: MTGSpacing.sm) {
                    HStack {
                        Image(systemName: MTGIcons.sparkles)
                            .font(.title2)
                            .foregroundStyle(LinearGradient.MTG.magicalGlow)
                        
                        Text("Planeswalker Tools")
                            .font(MTGTypography.title2)
                            .foregroundColor(Color.MTG.textPrimary)
                        
                        Image(systemName: MTGIcons.sparkles)
                            .font(.title2)
                            .foregroundStyle(LinearGradient.MTG.magicalGlow)
                    }
                    
                    Text("Harness the power of the multiverse")
                        .font(MTGTypography.caption)
                        .foregroundColor(Color.MTG.textSecondary)
                        .opacity(mysticalGlow ? 0.8 : 1.0)
                        .animation(MTGAnimation.pulse, value: mysticalGlow)
                }
                .mtgResponsivePadding()
                .mtgCardStyle()
                
                // Magical tools grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: MTGSpacing.md),
                    GridItem(.flexible(), spacing: MTGSpacing.md),
                ], spacing: MTGSpacing.lg) {
                    ForEach(toolItems) { item in
                        MTGToolButton(
                            item: item,
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
                            MTGAnimation.bounceSpring.delay(Double(item.id) * 0.05),
                            value: animateAppear
                        )
                    }
                }
                .mtgResponsivePadding()
                
                // Mystical results display
                if diceResult != nil {
                    VStack(spacing: MTGSpacing.md) {
                        if let result = diceResult {
                            MTGDiceResultView(
                                result: result,
                                selectedTool: selectedTool,
                                isRolling: isRollingDice
                            )
                        }
                    }
                    .mtgResponsivePadding()
                    .mtgCardStyle()
                    .transition(.scale.combined(with: .opacity))
                }
                
                Spacer()
            }
            .foregroundColor(.white.opacity(0.8))
            .onAppear {
                withAnimation(MTGAnimation.standardSpring.delay(0.1)) {
                    animateAppear = true
                    mysticalGlow = true
                }
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
    
    // MARK: - MTG Tool Button
    private struct MTGToolButton: View {
        let item: MTGToolItem
        let action: () -> Void
        @State private var isHovered = false
        
        var body: some View {
            Button(action: action) {
                VStack(spacing: MTGSpacing.sm) {
                    // Magical icon container
                    ZStack {
                        RoundedRectangle(cornerRadius: MTGCornerRadius.md)
                            .fill(LinearGradient.MTG.primaryButton)
                            .frame(width: 80, height: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: MTGCornerRadius.md)
                                    .stroke(LinearGradient.MTG.magicalGlow, lineWidth: MTGSpacing.borderWidth)
                                    .opacity(0.6)
                            )
                            .mtgGlow(color: Color.MTG.glowPrimary, radius: isHovered ? 16 : 8)
                        
                        VStack(spacing: 2) {
                            Text(item.magicalEffect)
                                .font(.title)
                            
                            Image(systemName: item.iconName)
                                .font(.system(size: 20, weight: .medium))
                                .foregroundStyle(LinearGradient.MTG.magicalGlow)
                        }
                    }
                    
                    // Spell information
                    VStack(spacing: 2) {
                        Text(item.label)
                            .font(MTGTypography.callout)
                            .foregroundColor(Color.MTG.textPrimary)
                            .fontWeight(.semibold)
                        
                        Text(item.description)
                            .font(MTGTypography.caption2)
                            .foregroundColor(Color.MTG.textSecondary)
                    }
                }
            }
            .buttonStyle(MTGScaleButtonStyle())
            .onHover { hovering in
                withAnimation(MTGAnimation.quick) {
                    isHovered = hovering
                }
            }
        }
    }
    
    // MARK: - MTG Dice Result View
    private struct MTGDiceResultView: View {
        let result: Int
        let selectedTool: MTGToolItem?
        let isRolling: Bool
        @State private var showSparkles = false
        
        var body: some View {
            VStack(spacing: MTGSpacing.md) {
                if let tool = selectedTool {
                    Text("\(tool.description) Cast!")
                        .font(MTGTypography.caption)
                        .foregroundColor(Color.MTG.textSecondary)
                }
                
                HStack(spacing: MTGSpacing.md) {
                    Text("Result:")
                        .font(MTGTypography.headline)
                        .foregroundColor(Color.MTG.textPrimary)
                    
                    ZStack {
                        Circle()
                            .fill(LinearGradient.MTG.magicalGlow)
                            .frame(width: 60, height: 60)
                            .mtgGlow(color: Color.MTG.glowSecondary, radius: 12)
                        
                        Text("\(result)")
                            .font(MTGTypography.lifeCounter)
                            .foregroundColor(Color.MTG.textPrimary)
                            .fontWeight(.bold)
                    }
                    .scaleEffect(isRolling ? 1.2 : 1.0)
                    .rotationEffect(.degrees(isRolling ? 360 : 0))
                    .animation(MTGAnimation.bounceSpring, value: isRolling)
                    
                    // Sparkle effects
                    if showSparkles {
                        HStack(spacing: 4) {
                            ForEach(0..<3, id: \.self) { _ in
                                Image(systemName: MTGIcons.sparkles)
                                    .foregroundStyle(LinearGradient.MTG.magicalGlow)
                                    .font(.caption)
                                    .opacity(showSparkles ? 1.0 : 0.0)
                                    .scaleEffect(showSparkles ? 1.0 : 0.5)
                            }
                        }
                        .animation(MTGAnimation.bounceSpring.delay(0.2), value: showSparkles)
                    }
                }
            }
            .onAppear {
                withAnimation(MTGAnimation.bounceSpring.delay(0.5)) {
                    showSparkles = true
                }
            }
        }
    }
}
