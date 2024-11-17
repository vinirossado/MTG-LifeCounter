//
//  LoadingAnimation.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 14.11.2024.
//

import SwiftUI

struct LoadingAnimation: View {
    
    @State private var isAnimating: Bool = false
    let timing: Double
    let colors: [Color]
    let frame: CGSize
    let circleCount: Int

    init(colors: [Color] = [.white, .green, .red, .blue],
         size: CGFloat = 90,
         speed: Double = 0.5,
         circleCount: Int = 3) {
        self.colors = colors
        self.timing = speed
        self.frame = CGSize(width: size, height: size)
        self.circleCount = circleCount
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<circleCount, id: \.self) { index in
                Circle()
                    .fill(colors[index % colors.count])
                    .frame(height: frame.height / CGFloat(circleCount))
                    .offset(self.offset(for: index))
            }
        }
        .frame(width: frame.width, height: frame.height, alignment: .center)
        .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
        .scaleEffect(isAnimating ? 1.1 : 1.0)
        .onAppear {
            withAnimation(
                Animation.linear(duration: timing)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating.toggle()
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


