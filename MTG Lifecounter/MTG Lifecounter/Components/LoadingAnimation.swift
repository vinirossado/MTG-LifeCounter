//
//  LoadingAnimation.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 14.11.2024.
//

import SwiftUI

struct LoadingAnimation: View {
    
    @State private var isAnimating: Bool = false
    @State private var rotationAngle: Double = 0
    let timing: Double
    let colors: [Color]
    let frame: CGSize
    let circleCount: Int

    init(colors: [Color] = [Color.MTG.blue, Color.MTG.red, Color.MTG.green, Color.MTG.white, Color.MTG.black],
         size: CGFloat = 90,
         speed: Double = 0.5,
         circleCount: Int = 5) {
        self.colors = colors
        self.timing = speed
        self.frame = CGSize(width: size, height: size)
        self.circleCount = circleCount
    }
    
    var body: some View {
        ZStack {
            // Outer mystical glow ring
            Circle()
                .stroke(LinearGradient.MTG.magicalGlow, lineWidth: 2)
                .frame(width: frame.width, height: frame.height)
                .opacity(0.3)
                .scaleEffect(isAnimating ? 1.2 : 1.0)
                .animation(MTGAnimation.pulse, value: isAnimating)
            
            // Mana orbs rotating around center
            ForEach(0..<circleCount, id: \.self) { index in
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [colors[index % colors.count], colors[index % colors.count].opacity(0.3)],
                            center: .center,
                            startRadius: 0,
                            endRadius: frame.height / CGFloat(circleCount * 2)
                        )
                    )
                    .frame(height: frame.height / CGFloat(circleCount))
                    .overlay(
                        Circle()
                            .stroke(colors[index % colors.count], lineWidth: 1)
                            .opacity(0.6)
                    )
                    .mtgGlow(color: colors[index % colors.count], radius: 4)
                    .offset(self.offset(for: index))
                    .scaleEffect(isAnimating ? 1.1 : 0.9)
            }
            
            // Central mystical core
            Circle()
                .fill(LinearGradient.MTG.magicalGlow)
                .frame(width: frame.width * 0.2, height: frame.height * 0.2)
                .mtgGlow(color: Color.MTG.glowPrimary, radius: 8)
                .scaleEffect(isAnimating ? 1.3 : 1.0)
                .opacity(isAnimating ? 0.8 : 0.5)
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .rotationEffect(Angle(degrees: rotationAngle))
        .onAppear {
            withAnimation(MTGAnimation.pulse) {
                isAnimating = true
            }
            
            withAnimation(
                Animation.linear(duration: timing * 2)
                    .repeatForever(autoreverses: false)
            ) {
                rotationAngle = 360
            }
        }
    }
    
    private func offset(for index: Int) -> CGSize {
        let angle = Double(index) * (360.0 / Double(circleCount))
        let radius = frame.width / 3
        return CGSize(
            width: cos(angle * .pi / 180) * (isAnimating ? radius : 0),
            height: sin(angle * .pi / 180) * (isAnimating ? radius : 0)
        )
    }
}

#Preview {
    Group {
        LoadingAnimation(colors: [.blue, .orange, .black, .green, .yellow], size: 120, speed: 0.9, circleCount: 5)
    }
}


