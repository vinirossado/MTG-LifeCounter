import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var isAnimating = false
    @State private var sparkleOffset: CGFloat = 0
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // Mystical background with animated gradient
                LinearGradient.MTG.mysticalBackground
                    .ignoresSafeArea()
                
                // Animated sparkle overlay
                AnimatedSparkles()
                
                VStack(spacing: MTGSpacing.xl) {
                    Spacer()
                    
                    // App title with mystical styling
                    VStack(spacing: MTGSpacing.md) {
                        Image(systemName: MTGIcons.sparkles)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(LinearGradient.MTG.magicalGlow)
                            .mtgGlow(color: Color.MTG.glowPrimary, radius: 20)
                            .scaleEffect(isAnimating ? 1.1 : 1.0)
                            .rotationEffect(.degrees(isAnimating ? 5 : -5))
                            .animation(MTGAnimation.breathe, value: isAnimating)
                        
                        Text("MTG Lifecounter")
                            .font(MTGTypography.heroTitle)
                            .foregroundStyle(LinearGradient.MTG.magicalGlow)
                            .mtgGlow(color: Color.MTG.textAccent, radius: 10)
                        
                        Text("Track your planeswalker's journey")
                            .font(MTGTypography.callout)
                            .foregroundColor(Color.MTG.textSecondary)
                            .opacity(isAnimating ? 0.8 : 1.0)
                            .animation(MTGAnimation.pulse, value: isAnimating)
                    }
                    
                    Spacer().frame(height: MTGSpacing.xxxl)
                    
                    // Start game button with magical styling
                    GeometryReader { geometry in
                        VStack(spacing: MTGSpacing.lg) {
                            StartGameButton(
                                action: { path.append("GameView") },
                                width: min(geometry.size.width * 0.7, 300)
                            )
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .frame(height: MTGLayout.buttonHeight + MTGSpacing.md)
                    
                    Spacer()
                }
                .mtgResponsivePadding()
                .navigationDestination(for: String.self) { view in
                    if view == "GameView" {
                        GameView()
                    }
                }
            }
        }
        .onAppear {
            withAnimation(MTGAnimation.breathe) {
                isAnimating = true
            }
        }
    }
}

// MARK: - Start Game Button
private struct StartGameButton: View {
    let action: () -> Void
    let width: CGFloat
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: MTGSpacing.sm) {
                Image(systemName: MTGIcons.gameController)
                    .font(.title2)
                
                Text("Enter the Arena")
                    .font(MTGTypography.buttonText)
                    .fontWeight(.semibold)
            }
            .foregroundColor(Color.MTG.textPrimary)
            .frame(height: MTGLayout.buttonHeight)
            .frame(maxWidth: width)
            .mtgButtonStyle(gradient: LinearGradient.MTG.primaryButton)
            .mtgGlow(color: Color.MTG.glowSecondary, radius: isPressed ? 15 : 8)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(MTGAnimation.quick, value: isPressed)
        }
        .pressEvents(onPress: { isPressed = true }, onRelease: { isPressed = false })
    }
}

// MARK: - Animated Sparkles Background
private struct AnimatedSparkles: View {
    @State private var sparkles: [SparkleData] = []
    
    var body: some View {
        ZStack {
            ForEach(sparkles, id: \.id) { sparkle in
                Image(systemName: "sparkle")
                    .foregroundStyle(LinearGradient.MTG.magicalGlow)
                    .font(.system(size: sparkle.size))
                    .position(sparkle.position)
                    .opacity(sparkle.opacity)
                    .scaleEffect(sparkle.scale)
                    .animation(
                        Animation.easeInOut(duration: sparkle.duration)
                            .repeatForever(autoreverses: true)
                            .delay(sparkle.delay),
                        value: sparkle.scale
                    )
            }
        }
        .onAppear {
            generateSparkles()
        }
    }
    
    private func generateSparkles() {
        sparkles = (0..<15).map { index in
            SparkleData(
                id: index,
                position: CGPoint(
                    x: CGFloat.random(in: 50...350),
                    y: CGFloat.random(in: 100...700)
                ),
                size: CGFloat.random(in: 8...16),
                opacity: Double.random(in: 0.3...0.7),
                scale: CGFloat.random(in: 0.5...1.2),
                duration: Double.random(in: 2...4),
                delay: Double.random(in: 0...2)
            )
        }
    }
}

// MARK: - Sparkle Data Model
private struct SparkleData {
    let id: Int
    let position: CGPoint
    let size: CGFloat
    let opacity: Double
    let scale: CGFloat
    let duration: Double
    let delay: Double
}

// MARK: - Press Events Extension
extension View {
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self
            .scaleEffect(1.0)
            .onTapGesture {
                onPress()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    onRelease()
                }
            }
    }
}
#Preview {
    ContentView()
}
