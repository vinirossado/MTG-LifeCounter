import SwiftUI
@_exported import HotSwiftUI

struct ContentView: View {
  @State private var path = NavigationPath()
  @EnvironmentObject var screenWakeManager: ScreenWakeManager

  var body: some View {
    NavigationStack(path: $path) {
      GeometryReader { geometry in
        ZStack {
          backgroundLayers
          mainContent(geometry: geometry)
        }
      }
      .ignoresSafeArea(.all, edges: .all)
      .onAppear {
        // Ensure screen wake is disabled on home screen to allow normal sleep behavior
        screenWakeManager.disableScreenWake()
      }
    }
    .eraseToAnyView()
  }
  
  @ObserveInjection var redraw
  private var backgroundLayers: some View {
    ZStack {
      // Enhanced mystical background with layers
      LinearGradient.MTG.mysticalBackground
        .ignoresSafeArea(.all)

      // Magical energy field background
      MagicalEnergyField()

      // Mystical corner frames
//      MysticalCornerFrames()
    }
  }
  
  private func mainContent(geometry: GeometryProxy) -> some View {
    VStack(spacing: MTGSpacing.xl) {
      Spacer()
        .frame(minHeight: geometry.safeAreaInsets.top + MTGSpacing.lg)
      
      titleSection
      
      Spacer()
        .frame(height: max(MTGSpacing.xxxl, geometry.size.height * 0.1))
      
      startGameSection
      
      Spacer()
        .frame(minHeight: geometry.safeAreaInsets.bottom + MTGSpacing.lg)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.horizontal, isIPad ? MTGSpacing.xxxl : MTGSpacing.lg)
    .navigationDestination(for: String.self) { view in
      if view == "GameView" {
        GameView()
      }
    }
  }
  
  private var titleSection: some View {
    VStack(spacing: MTGSpacing.lg) {
      mtgLogoSection
      titleText
      gameFormatsCarousel
    }
  }
  
  private var mtgLogoSection: some View {
    VStack(spacing: MTGSpacing.md) {
      // MTG Planeswalker Spark
      ZStack {
        // Outer mana circle
        Circle()
          .stroke(LinearGradient.MTG.magicalGlow, lineWidth: isIPad ? 4 : 3)
          .frame(width: isIPad ? 140 : 110, height: isIPad ? 140 : 110)
          .opacity(0.8)
        
        // Five elemental symbols in orbit
        elementalSymbolsOrb
        
        // Central planeswalker spark
        Image(systemName: "flame.fill")
          .resizable()
          .scaledToFit()
          .frame(width: isIPad ? 50 : 40, height: isIPad ? 50 : 40)
          .foregroundStyle(LinearGradient.MTG.magicalGlow)
          .mtgGlow(color: Color.MTG.glowPrimary, radius: isIPad ? 20 : 15)
      }
      
      // Elemental cost indicators
//      HStack(spacing: MTGSpacing.sm) {
//        ForEach(0..<5, id: \.self) { index in
//          elementalSymbolBadge(for: index)
//        }
//      }
    }
  }
  
  private var elementalSymbolsOrb: some View {
    let size = isIPad ? 140.0 : 110.0
    let center = size / 2
    let radius = size * 0.32
    
    return ForEach(0..<5, id: \.self) { index in
      ZStack {
        Circle()
          .fill(manaColorBackground(for: index))
          .frame(width: isIPad ? 28 : 24, height: isIPad ? 28 : 24)
          .overlay(
            Circle()
              .stroke(Color.MTG.textPrimary, lineWidth: 1.5)
              .opacity(0.6)
          )
        
        Text(manaSymbolText(for: index))
          .font(.system(size: isIPad ? 18 : 16, weight: .medium))
          .foregroundColor(.black)
      }
      .position(
        x: center + cos(Double(index) * .pi * 2 / 5) * radius,
        y: center + sin(Double(index) * .pi * 2 / 5) * radius
      )
    }
    .frame(width: size, height: size)
  }
  
//  private func elementalSymbolBadge(for index: Int) -> some View {
//    ZStack {
//      Circle()
//        .fill(manaColorBackground(for: index))
//        .frame(width: isIPad ? 24 : 20, height: isIPad ? 24 : 20)
//        .overlay(
//          Circle()
//            .stroke(Color.MTG.textPrimary, lineWidth: 1)
//            .opacity(0.8)
//        )
//      
//      Text(manaSymbolText(for: index))
//        .font(.system(size: isIPad ? 14 : 12, weight: .medium))
//        .foregroundColor(.black)
//    }
//  }
  
  private var titleText: some View {
    VStack(spacing: MTGSpacing.md) {
      // MTG Logo Style
      HStack(spacing: MTGSpacing.xs) {
//        Text("MAGIC")
//          .font(.system(size: isIPad ? 42 : 32, weight: .heavy, design: .default))
//          .foregroundStyle(LinearGradient.MTG.magicalGlow)
//          .mtgGlow(color: Color.MTG.textAccent, radius: isIPad ? 12 : 8)
//          .tracking(isIPad ? 4 : 2)
//        
//        Text("THE")
//          .font(.system(size: isIPad ? 20 : 16, weight: .medium, design: .default))
//          .foregroundColor(Color.MTG.textSecondary)
//          .tracking(isIPad ? 3 : 2)
//          .offset(y: isIPad ? 8 : 6)
        
        Text("LIFECOUNTER")
          .font(.system(size: isIPad ? 42 : 32, weight: .heavy, design: .default))
          .foregroundStyle(LinearGradient.MTG.magicalGlow)
          .mtgGlow(color: Color.MTG.textAccent, radius: isIPad ? 12 : 8)
          .tracking(isIPad ? 4 : 2)
      }

//      Text("LIFECOUNTER")
//        .font(.system(size: isIPad ? 24 : 18, weight: .semibold, design: .default))
//        .foregroundStyle(LinearGradient.MTG.whiteGradient)
//        .tracking(isIPad ? 8 : 6)
//        .opacity(0.9)

//      mtgDivider

      Text("Track life totals across the multiverse")
        .font(isIPad ? MTGTypography.callout : MTGTypography.caption)
        .foregroundColor(Color.MTG.textSecondary)
        .multilineTextAlignment(.center)
        .opacity(0.9)
    }
  }
  
  private var mtgDivider: some View {
    HStack(spacing: MTGSpacing.sm) {
      // Left elemental symbols
      HStack(spacing: MTGSpacing.xs) {
        ForEach([0, 1], id: \.self) { index in
          Text(manaSymbolText(for: index))
            .font(.system(size: isIPad ? 16 : 14, weight: .medium))
            .foregroundColor(.black)
            .frame(width: isIPad ? 20 : 16, height: isIPad ? 20 : 16)
            .background(
              Circle()
                .fill(manaColorBackground(for: index))
                .overlay(
                  Circle()
                    .stroke(Color.MTG.textPrimary, lineWidth: 1)
                    .opacity(0.6)
                )
            )
        }
      }
      
      Rectangle()
        .fill(LinearGradient.MTG.magicalGlow)
        .frame(width: isIPad ? 60 : 40, height: 1.5)
        .opacity(0.6)

      Image(systemName: "flame.fill")
        .foregroundStyle(LinearGradient.MTG.magicalGlow)
        .font(isIPad ? .caption : .caption2)

      Rectangle()
        .fill(LinearGradient.MTG.magicalGlow)
        .frame(width: isIPad ? 60 : 40, height: 1.5)
        .opacity(0.6)
      
      // Right elemental symbols
      HStack(spacing: MTGSpacing.xs) {
        ForEach([3, 4], id: \.self) { index in
          Text(manaSymbolText(for: index))
            .font(.system(size: isIPad ? 16 : 14, weight: .medium))
            .foregroundColor(.black)
            .frame(width: isIPad ? 20 : 16, height: isIPad ? 20 : 16)
            .background(
              Circle()
                .fill(manaColorBackground(for: index))
                .overlay(
                  Circle()
                    .stroke(Color.MTG.textPrimary, lineWidth: 1)
                    .opacity(0.6)
                )
            )
        }
      }
    }
  }
  
  private var gameFormatsCarousel: some View {
    VStack(spacing: MTGSpacing.sm) {
      Text("CHOOSE YOUR FORMAT")
        .font(.system(size: isIPad ? 14 : 12, weight: .semibold))
        .foregroundColor(Color.MTG.textSecondary)
        .tracking(isIPad ? 2 : 1)
        .opacity(0.8)
        HStack(spacing: MTGSpacing.md) {
          ForEach(gameFormats, id: \.name) { format in
            GameFormatCard(format: format)
          }
        }
        .padding(.horizontal, MTGSpacing.lg)
      
      .frame(height: isIPad ? 120 : 100)
    }
  }
  
  private var gameFormats: [GameFormat] {
    [
      GameFormat(name: "Commander", description: "100-card singleton", startingLife: 40, icon: "crown.fill", color: Color.MTG.gold),
      GameFormat(name: "Standard", description: "Recent sets", startingLife: 20, icon: "star.fill", color: Color.MTG.blue),
      GameFormat(name: "Modern", description: "2003 onwards", startingLife: 20, icon: "bolt.fill", color: Color.MTG.red),
      GameFormat(name: "Pioneer", description: "2012 onwards", startingLife: 20, icon: "leaf.fill", color: Color.MTG.green),
      GameFormat(name: "Legacy", description: "All cards", startingLife: 20, icon: "infinity", color: Color.MTG.white)
    ]
  }
  
  private var startGameSection: some View {
    VStack(spacing: MTGSpacing.lg) {
      MTGStartButton(
        action: {
          withAnimation(MTGAnimation.standardSpring) {
            path.append("GameView")
          }
        },
        width: isIPad ? 350 : 280
      )

      // MTG flavor text
      VStack(spacing: MTGSpacing.xs) {
        Text("May your elements align in victory")
          .font(isIPad ? MTGTypography.callout : MTGTypography.caption)
          .foregroundColor(Color.MTG.textSecondary)
          .italic()
          .opacity(0.8)

        HStack(spacing: MTGSpacing.xs) {
          Text(manaSymbolText(for: 0))
            .font(.system(size: isIPad ? 16 : 14, weight: .medium))
            .foregroundColor(.black)
            .frame(width: isIPad ? 16 : 14, height: isIPad ? 16 : 14)
            .background(
              Circle()
                .fill(manaColorBackground(for: 0))
                .overlay(Circle().stroke(Color.MTG.textPrimary, lineWidth: 0.5))
            )
          
          Text(manaSymbolText(for: 2))
            .font(.system(size: isIPad ? 16 : 14, weight: .medium))
            .foregroundColor(.black)
            .frame(width: isIPad ? 16 : 14, height: isIPad ? 16 : 14)
            .background(
              Circle()
                .fill(manaColorBackground(for: 2))
                .overlay(Circle().stroke(Color.MTG.textPrimary, lineWidth: 0.5))
            )
          
          Text(manaSymbolText(for: 4))
            .font(.system(size: isIPad ? 16 : 14, weight: .medium))
            .foregroundColor(.black)
            .frame(width: isIPad ? 16 : 14, height: isIPad ? 16 : 14)
            .background(
              Circle()
                .fill(manaColorBackground(for: 4))
                .overlay(Circle().stroke(Color.MTG.textPrimary, lineWidth: 0.5))
            )
        }
        .opacity(1.0)
      }
    }
  }

  // Helper functions for enhanced elemental symbols
  private func manaSymbolText(for index: Int) -> String {
    let symbols = ["☀︎", "💧", "🌙", "🔥", "🌿"]  // Sun, Water Drop, Moon, Fire, Leaf
    return symbols[index]
  }

  private func manaColorBackground(for index: Int) -> Color {
    let colors = [
      Color.yellow.opacity(0.9),     // Light/Sun - Bright Yellow
      Color.blue.opacity(0.9),       // Water - Ocean Blue  
      Color.purple.opacity(0.9),     // Shadow/Moon - Deep Purple
      Color.red.opacity(0.9),        // Fire - Flame Red
      Color.green.opacity(0.9)       // Nature/Life - Forest Green
    ]
    return colors[index]
  }
}

// MARK: - Game Format Data Model
private struct GameFormat {
  let name: String
  let description: String
  let startingLife: Int
  let icon: String
  let color: Color
}

// MARK: - Game Format Card
private struct GameFormatCard: View {
  let format: GameFormat
  @State private var isHovered = false
  
  var body: some View {
    VStack(spacing: MTGSpacing.xs) {
      // Format icon
      Image(systemName: format.icon)
        .font(.system(size: isIPad ? 22 : 18, weight: .bold))
        .foregroundColor(format.color)
        .frame(width: isIPad ? 36 : 32, height: isIPad ? 36 : 32)
        .background(
          Circle()
            .fill(format.color.opacity(0.2))
            .overlay(
              Circle()
                .stroke(format.color, lineWidth: 1.5)
                .opacity(0.6)
            )
        )
      
      // Format name
      Text(format.name)
        .font(.system(size: isIPad ? 13 : 11, weight: .bold))
        .foregroundColor(Color.MTG.textPrimary)
        .multilineTextAlignment(.center)
        .lineLimit(1)
        .minimumScaleFactor(0.8)
      
      // Format description
      Text(format.description)
        .font(.system(size: isIPad ? 10 : 9, weight: .medium))
        .foregroundColor(Color.MTG.textSecondary)
        .multilineTextAlignment(.center)
        .lineLimit(2)
        .minimumScaleFactor(0.8)
      
      // Starting life
      Text("\(format.startingLife) Life")
        .font(.system(size: isIPad ? 11 : 9, weight: .semibold))
        .foregroundColor(format.color)
    }
    .frame(width: isIPad ? 90 : 75, height: isIPad ? 95 : 80) // Fixed size for alignment
    .padding(.vertical, MTGSpacing.xs)
    .padding(.horizontal, MTGSpacing.xs)
    .background(
      RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
        .fill(Color.MTG.cardBackground.opacity(0.6))
        .overlay(
          RoundedRectangle(cornerRadius: MTGCornerRadius.sm)
            .stroke(format.color.opacity(0.4), lineWidth: 1)
        )
    )
    .scaleEffect(isHovered ? 1.05 : 1.0)
    .onTapGesture {
      withAnimation(MTGAnimation.quick) {
        isHovered = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        isHovered = false
      }
    }
  }
}

// MARK: - MTG Start Button
private struct MTGStartButton: View {
  let action: () -> Void
  let width: CGFloat
  @State private var isPressed = false

  var body: some View {
    Button(action: action) {
      ZStack {
        // MTG Card-style background
        RoundedRectangle(cornerRadius: MTGCornerRadius.md)
          .fill(LinearGradient.MTG.cardBackground)
          .frame(height: (isIPad ? MTGLayout.buttonHeight + MTGSpacing.lg : MTGLayout.buttonHeight + MTGSpacing.md))
          .frame(maxWidth: width)
          .overlay(
            RoundedRectangle(cornerRadius: MTGCornerRadius.md)
              .stroke(LinearGradient.MTG.magicalGlow, lineWidth: 2)
              .opacity(0.8)
          )
          .mtgGlow(color: Color.MTG.glowSecondary, radius: isIPad ? 12 : 8)
          .scaleEffect(isPressed ? 0.96 : 1.0)

        // Button content with MTG styling
        HStack(spacing: isIPad ? MTGSpacing.md : MTGSpacing.sm) {
          // Planeswalker spark icon
          ZStack {
            Circle()
              .fill(LinearGradient.MTG.magicalGlow.opacity(0.3))
              .frame(width: isIPad ? 44 : 36, height: isIPad ? 44 : 36)
              .scaleEffect(isPressed ? 1.1 : 1.0)

            Image(systemName: "flame.fill")
              .font(.system(size: isIPad ? 20 : 16, weight: .bold))
              .foregroundStyle(LinearGradient.MTG.magicalGlow)
          }

          VStack(spacing: 2) {
            Text("Enter the Arena")
              .font(.system(size: isIPad ? 18 : 16, weight: .bold))
              .foregroundColor(Color.MTG.textPrimary)

            Text("Begin your duel")
              .font(.system(size: isIPad ? 12 : 10, weight: .medium))
              .foregroundColor(Color.MTG.textSecondary)
              .opacity(0.9)
          }

          // Elemental cost representation
          HStack(spacing: 2) {
            ForEach(0..<3, id: \.self) { index in
              Circle()
                .fill(manaColorBackground(for: index))
                .frame(width: isIPad ? 20 : 16, height: isIPad ? 20 : 16)
                .overlay(
                  Circle()
                    .stroke(Color.MTG.textPrimary, lineWidth: 1)
                    .opacity(0.6)
                )
                .overlay(
                  Text(manaSymbolText(for: index))
                    .font(.system(size: isIPad ? 14 : 12, weight: .medium))
                    .foregroundColor(.black)
                )
                .opacity(isPressed ? 1.0 : 0.8)
                .scaleEffect(isPressed ? 1.1 : 1.0)
            }
          }
        }
        .frame(maxWidth: width)
      }
    }
    .buttonStyle(PlainButtonStyle())
    .onTapGesture {
      // Haptic feedback
      let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
      impactFeedback.impactOccurred()
      
      isPressed = true
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isPressed = false
        action()
      }
    }
    .accessibilityLabel("Enter the Arena")
    .accessibilityHint("Start a new Magic: The Gathering game")
  }
  
  // Helper functions (moved inside the struct)
  private func manaSymbolText(for index: Int) -> String {
    let symbols = ["☀︎", "💧", "🌙"]  // Sun, Water Drop, Moon
    return symbols[index]
  }

  private func manaColorBackground(for index: Int) -> Color {
    let colors = [Color.yellow.opacity(0.9), Color.blue.opacity(0.9), Color.purple.opacity(0.9)]
    return colors[index]
  }
}

// MARK: - MTG Themed Animated Background
private struct AnimatedSparkles: View {
  @State private var manaSymbols: [MTGManaSymbol] = []
  @State private var screenSize: CGSize = .zero

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ForEach(manaSymbols, id: \.id) { symbol in
          symbolView(for: symbol)
        }
      }
      .onAppear {
        screenSize = geometry.size
        generateMTGSymbols()
      }
      .onChange(of: geometry.size) { newSize in
        screenSize = newSize
        generateMTGSymbols()
      }
    }
  }
  
  private func symbolView(for symbol: MTGManaSymbol) -> some View {
    ZStack {
      symbolBackground(for: symbol)
      symbolText(for: symbol)
    }
    .position(symbol.position)
    .scaleEffect(symbol.scale)
    .rotationEffect(.degrees(symbol.rotation))
    .animation(
      Animation.easeInOut(duration: symbol.duration)
        .repeatForever(autoreverses: true)
        .delay(symbol.delay),
      value: symbol.scale
    )
  }
  
  private func symbolBackground(for symbol: MTGManaSymbol) -> some View {
    Circle()
      .fill(symbol.backgroundColor.opacity(symbol.opacity))
      .frame(width: symbol.size, height: symbol.size)
      .overlay(
        Circle()
          .stroke(Color.MTG.textPrimary.opacity(0.3), lineWidth: 1)
      )
  }
  
  private func symbolText(for symbol: MTGManaSymbol) -> some View {
    Text(symbol.text)
      .font(.system(size: symbol.size * 0.6, weight: .bold))
      .foregroundColor(Color.MTG.textPrimary.opacity(0.8))
  }

  private func generateMTGSymbols() {
    guard screenSize != .zero else { return }
    
    let symbolsAndColors = getElementalSymbolsAndColors()
    let symbolCount = isIPad ? 20 : 15
    
    manaSymbols = (0..<symbolCount).map { index in
      createRandomSymbol(index: index, symbolsAndColors: symbolsAndColors)
    }
  }
  
  private func getElementalSymbolsAndColors() -> ([String], [Color]) {
    let symbols = ["☀︎", "💧", "🌙", "🔥", "🌿", "⚡", "💎", "⭐"]
    let colors = createElementalColors()
    return (symbols, colors)
  }
  
  private func createElementalColors() -> [Color] {
    let baseOpacity: Double = 0.8
    return [
      Color.yellow.opacity(baseOpacity),
      Color.blue.opacity(baseOpacity),
      Color.purple.opacity(baseOpacity),
      Color.red.opacity(baseOpacity),
      Color.green.opacity(baseOpacity),
      Color.orange.opacity(baseOpacity),
      Color.cyan.opacity(baseOpacity),
      Color.white.opacity(baseOpacity)
    ]
  }
  
  private func createRandomSymbol(index: Int, symbolsAndColors: ([String], [Color])) -> MTGManaSymbol {
    let (symbols, colors) = symbolsAndColors
    let symbolIndex = Int.random(in: 0..<symbols.count)
    
    let symbolText = symbols[symbolIndex]
    let symbolColor = colors[symbolIndex]
    let randomPosition = createRandomPosition()
    let randomSize = createRandomSize()
    let randomOpacity = Double.random(in: 0.1...0.3)
    let randomScale = CGFloat.random(in: 0.8...1.2)
    let randomRotation = Double.random(in: 0...360)
    let randomDuration = Double.random(in: 3...7)
    let randomDelay = Double.random(in: 0...4)
    
    return createMTGManaSymbol(
      id: index,
      text: symbolText,
      backgroundColor: symbolColor,
      position: randomPosition,
      size: randomSize,
      opacity: randomOpacity,
      scale: randomScale,
      rotation: randomRotation,
      duration: randomDuration,
      delay: randomDelay
    )
  }
  
  private func createMTGManaSymbol(
    id: Int,
    text: String,
    backgroundColor: Color,
    position: CGPoint,
    size: CGFloat,
    opacity: Double,
    scale: CGFloat,
    rotation: Double,
    duration: Double,
    delay: Double
  ) -> MTGManaSymbol {
    return MTGManaSymbol(
      id: id,
      text: text,
      backgroundColor: backgroundColor,
      position: position,
      size: size,
      opacity: opacity,
      scale: scale,
      rotation: rotation,
      duration: duration,
      delay: delay
    )
  }
  
  private func createRandomPosition() -> CGPoint {
    return CGPoint(
      x: CGFloat.random(in: 40...(screenSize.width - 40)),
      y: CGFloat.random(in: 100...(screenSize.height - 100))
    )
  }
  
  private func createRandomSize() -> CGFloat {
    let minSize: CGFloat = isIPad ? 20 : 16
    let maxSize: CGFloat = isIPad ? 36 : 28
    return CGFloat.random(in: minSize...maxSize)
  }
}

// MARK: - Elemental Symbol Data Model
private struct MTGManaSymbol {
  let id: Int
  let text: String
  let backgroundColor: Color
  let position: CGPoint
  let size: CGFloat
  let opacity: Double
  let scale: CGFloat
  let rotation: Double
  let duration: Double
  let delay: Double
}

// MARK: - Press Events Extension (Deprecated - keeping for compatibility)
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

// MARK: - Magical Energy Field
private struct MagicalEnergyField: View {
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        // Mystical energy waves
        ForEach(0..<4, id: \.self) { index in
          Ellipse()
            .stroke(
              LinearGradient.MTG.magicalGlow,
              style: StrokeStyle(lineWidth: 1, dash: [10, 20])
            )
            .frame(
              width: min(geometry.size.width * 0.6, 300) + CGFloat(index * (isIPad ? 120 : 100)),
              height: min(geometry.size.height * 0.3, 150) + CGFloat(index * (isIPad ? 60 : 50))
            )
            .opacity(0.2 - Double(index) * 0.04)
            .rotationEffect(.degrees(Double(index) * 45))
        }
      }
    }
  }
}

// MARK: - Mystical Corner Frames
//private struct MysticalCornerFrames: View {
//  var body: some View {
//    GeometryReader { geometry in
//      ZStack {
//        // Four corner frames
//        VStack {
//          HStack {
//            CornerFrame()
//            Spacer()
//            CornerFrame()
//              .rotationEffect(.degrees(90))
//          }
//          Spacer()
//          HStack {
//            CornerFrame()
//              .rotationEffect(.degrees(-90))
//            Spacer()
//            CornerFrame()
//              .rotationEffect(.degrees(180))
//          }
//        }
//        .padding(isIPad ? MTGSpacing.xxxl : MTGSpacing.xl)
//      }
//    }
//  }
//}

// MARK: - Corner Frame Component
//private struct CornerFrame: View {
//  var body: some View {
//    let frameSize: CGFloat = isIPad ? 50 : 40
//    let strokeWidth: CGFloat = isIPad ? 3 : 2
//    
//    return ZStack {
//      // Main corner lines
//      Path { path in
//        path.move(to: CGPoint(x: 0, y: frameSize))
//        path.addLine(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: frameSize, y: 0))
//      }
//      .stroke(LinearGradient.MTG.magicalGlow, lineWidth: strokeWidth)
//      .opacity(0.7)
//      .mtgGlow(color: Color.MTG.glowPrimary, radius: isIPad ? 8 : 6)
//
//      // Decorative elements
//      VStack(alignment: .leading, spacing: isIPad ? 6 : 4) {
//        HStack(spacing: isIPad ? 6 : 4) {
//          Circle()
//            .fill(Color.MTG.gold)
//            .frame(width: isIPad ? 8 : 6, height: isIPad ? 8 : 6)
//            .mtgGlow(color: Color.MTG.gold, radius: isIPad ? 8 : 6)
//
//          Rectangle()
//            .fill(LinearGradient.MTG.magicalGlow)
//            .frame(width: isIPad ? 25 : 20, height: isIPad ? 2 : 1.5)
//            .opacity(0.8)
//
//          Spacer()
//        }
//
//        HStack(spacing: isIPad ? 6 : 4) {
//          Rectangle()
//            .fill(LinearGradient.MTG.magicalGlow)
//            .frame(width: isIPad ? 2 : 1.5, height: isIPad ? 25 : 20)
//            .opacity(0.8)
//
//          Spacer()
//        }
//
//        Spacer()
//      }
//      .frame(width: frameSize, height: frameSize)
//    }
//  }
//}
