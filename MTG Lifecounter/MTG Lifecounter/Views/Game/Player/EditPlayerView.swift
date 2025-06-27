import SwiftUI

struct EditPlayerView: View {
    @Binding var player: Player
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State private var playerName: String = ""
    @State private var viewHeight: CGFloat = 0
    @State private var orientation = UIDeviceOrientation.unknown
    @State private var isVisible = false
    @State private var mysticalGlow: Double = 0.3
    @State private var cardRotation: Double = 0
    @State private var showCommanderSearch = false
    
    // Dynamic sizing based on device
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    // Dynamic font sizes
    private var titleFontSize: CGFloat {
        if isIPad { return 42 }
        return isLandscape ? 28 : 32
    }
    
    private var labelFontSize: CGFloat {
        if isIPad { return 20 }
        return isLandscape ? 16 : 18
    }
    
    private var inputFontSize: CGFloat {
        if isIPad { return 26 }
        return isLandscape ? 20 : 22
    }
    
    // Dynamic spacing
    private var verticalPadding: CGFloat {
        if isIPad { return 40 }
        return isLandscape ? 16 : 24
    }
    
    private var horizontalPadding: CGFloat {
        if isIPad { return 40 }
        return isLandscape ? 24 : 24
    }
    
    // Dynamic button properties
    private var buttonWidth: CGFloat {
        if isIPad { return 160 }
        return isLandscape ? 120 : 100
    }
    
    private var buttonSpacing: CGFloat {
        if isIPad { return 40 }
        return isLandscape ? 30 : 20
    }
    
    private var buttonVerticalPadding: CGFloat {
        if isIPad { return 18 }
        return 14
    }
    
    // Background color based on color scheme
    private var backgroundColor: Color {
        colorScheme == .dark ? Color.darkNavyBackground : Color(UIColor.systemGroupedBackground)
    }
    
    // Text color based on color scheme
    private var textColor: Color {
        colorScheme == .dark ? Color.lightGrayText : Color.primary
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Mystical background overlay
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
                
                // Main spell scroll container
                VStack(spacing: 0) {
                    // Content container with mystical styling
                    ScrollView {
                        VStack(alignment: .center, spacing: isIPad ? 30 : 20) {
                            // Mystical header
                            VStack(spacing: 16) {
                                // Decorative header with mana symbols
                                HStack {
                                    Circle()
                                        .fill(LinearGradient(
                                            colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 10, height: 10)
                                        .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
                                    
                                    Rectangle()
                                        .fill(LinearGradient(
                                            colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .frame(height: 1.5)
                                    
                                    Text("⚡")
                                        .font(.system(size: 16))
                                        .foregroundColor(.yellow.opacity(0.8))
                                    
                                    Rectangle()
                                        .fill(LinearGradient(
                                            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ))
                                        .frame(height: 1.5)
                                    
                                    Circle()
                                        .fill(LinearGradient(
                                            colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ))
                                        .frame(width: 10, height: 10)
                                        .overlay(Circle().stroke(Color.white.opacity(0.4), lineWidth: 1))
                                }
                                .padding(.horizontal, 20)
                                
                                // Title with mystical styling
                                Text("Planeswalker Identity")
                                    .font(.system(size: titleFontSize, weight: .bold, design: .serif))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [Color.white, Color.lightGrayText],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
                            }
                            .padding(.top, verticalPadding)
                            .padding(.bottom, isIPad ? 20 : 10)
                            
                            // Adaptive layout for landscape mode
                            if isLandscape {
                                // Landscape layout
                                HStack(alignment: .top, spacing: 20) {
                                    VStack(spacing: 20) {
                                        // Input field section
                                        mtgPlayerInputSection()
                                        
                                        // Commander section
                                        mtgCommanderSection()
                                    }
                                    
                                    // Button section
                                    mtgButtonSection()
                                }
                                .padding(.horizontal, horizontalPadding)
                                .padding(.bottom, verticalPadding)
                            } else {
                                // Portrait layout
                                VStack(spacing: isIPad ? 40 : 30) {
                                    // Input field section
                                    mtgPlayerInputSection()
                                    
                                    // Commander section
                                    mtgCommanderSection()
                                    
                                    Spacer(minLength: isIPad ? 40 : 20)
                                    
                                    // Button section
                                    mtgButtonSection()
                                }
                                .padding(.horizontal, horizontalPadding)
                                .padding(.bottom, verticalPadding)
                                .frame(minHeight: geometry.size.height * 0.7)
                            }
                        }
                        .frame(minHeight: geometry.size.height)
                    }
                    .background(
                        // Spell scroll background
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.darkNavyBackground,
                                        Color.oceanBlueBackground.opacity(0.95),
                                        Color.darkNavyBackground
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .stroke(
                                        LinearGradient(
                                            colors: [
                                                Color.blue.opacity(0.6),
                                                Color.purple.opacity(0.4),
                                                Color.blue.opacity(0.6)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                            )
                            .shadow(color: Color.blue.opacity(mysticalGlow), radius: 15, x: 0, y: 5)
                            .shadow(color: Color.black.opacity(0.6), radius: 25, x: 0, y: 10)
                    )
                    .frame(maxWidth: isIPad ? 500 : geometry.size.width - 40)
                    .scaleEffect(isVisible ? 1.0 : 0.9)
                    .opacity(isVisible ? 1.0 : 0.0)
                    .rotation3DEffect(
                        .degrees(cardRotation),
                        axis: (x: 1, y: 0, z: 0)
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewHeight = geometry.size.height
                    // Initialize with current player name
                    playerName = player.name
                    
                    // Set initial orientation
                    updateOrientation()
                    
                    // Entrance animations
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        isVisible = true
                    }
                    
                    // Mystical glow animation
                    withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                        mysticalGlow = 0.6
                    }
                    
                    // Subtle card animation
                    withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
                        cardRotation = 1
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    updateOrientation()
                }
            }
        }
        .sheet(isPresented: $showCommanderSearch) {
            CommanderSearchView(player: $player)
        }
    }
    
    // Helper method to track orientation changes
    private func updateOrientation() {
        orientation = UIDevice.current.orientation
    }
    
    // MTG-themed player input section
    private func mtgPlayerInputSection() -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(.blue.opacity(0.7))
                    .font(.system(size: 18))
                Text("Planeswalker Name")
                    .font(.system(size: labelFontSize, weight: .semibold, design: .serif))
                    .foregroundColor(.lightGrayText)
            }
            
            Text("Choose your identity in the multiverse")
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.mutedSilverText)
                .italic()
                .padding(.leading, 4)
            
            TextField("", text: Binding(
                get: { self.playerName.isEmpty ? self.player.name : self.playerName },
                set: { self.playerName = $0 }
            ))
            .font(.system(size: inputFontSize, weight: .medium, design: .serif))
            .padding(.vertical, isIPad ? 16 : 14)
            .padding(.horizontal, isIPad ? 20 : 16)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.oceanBlueBackground.opacity(0.6),
                                Color.darkNavyBackground.opacity(0.8)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                            .stroke(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                    .shadow(color: Color.blue.opacity(0.2), radius: 6, x: 0, y: 3)
            )
            .foregroundColor(.lightGrayText)
            .autocapitalization(.words)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.oceanBlueBackground.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color.blue.opacity(0.4), Color.purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .frame(maxWidth: isLandscape && !isIPad ? nil : .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // MTG-themed commander section
    private func mtgCommanderSection() -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 16 : 12) {
            HStack(spacing: 8) {
                Image(systemName: "crown.fill")
                    .foregroundColor(.yellow.opacity(0.8))
                    .font(.system(size: 18))
                Text("Commander")
                    .font(.system(size: labelFontSize, weight: .semibold, design: .serif))
                    .foregroundColor(.lightGrayText)
            }
            
            Text("Choose your legendary creature to lead your deck")
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.mutedSilverText)
                .italic()
                .padding(.leading, 4)
            
            // Commander display or search button
            if let commanderName = player.commanderName, !commanderName.isEmpty {
                // Display current commander
                HStack(spacing: 12) {
                    // Commander image placeholder or actual image
                    AsyncImage(url: URL(string: player.commanderImageURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .onAppear {
                                    print("✅ EditPlayer commander image loaded")
                                }
                        case .failure(let error):
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(
                                    colors: [Color.red.opacity(0.3), Color.red.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .overlay(
                                    Image(systemName: "exclamationmark.triangle")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 16))
                                )
                                .onAppear {
                                    print("❌ EditPlayer commander image failed: \(error.localizedDescription)")
                                }
                        case .empty:
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                        .scaleEffect(0.7)
                                )
                        @unknown default:
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(
                                    colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .overlay(
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.yellow.opacity(0.6))
                                        .font(.system(size: 16))
                                )
                        }
                    }
                    .frame(width: 50, height: 70)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(commanderName)
                            .font(.system(size: 16, weight: .semibold, design: .serif))
                            .foregroundColor(.lightGrayText)
                            .lineLimit(2)
                        
                        if let typeLine = player.commanderTypeLine {
                            Text(typeLine)
                                .font(.system(size: 12, weight: .medium, design: .serif))
                                .foregroundColor(.mutedSilverText)
                                .lineLimit(1)
                        }
                        
                        // Mana cost or color identity
                        if let colors = player.commanderColors, !colors.isEmpty {
                            HStack(spacing: 2) {
                                ForEach(colors.prefix(5), id: \.self) { color in
                                    Circle()
                                        .fill(manaColor(for: color))
                                        .frame(width: 12, height: 12)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                                        )
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showCommanderSearch = true
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue.opacity(0.8))
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.oceanBlueBackground.opacity(0.4),
                                    Color.darkNavyBackground.opacity(0.6)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    LinearGradient(
                                        colors: [Color.yellow.opacity(0.4), Color.blue.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                )
            } else {
                // Search for commander button
                Button(action: {
                    showCommanderSearch = true
                }) {
                    HStack(spacing: 12) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(
                                    colors: [Color.yellow.opacity(0.2), Color.orange.opacity(0.1)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 50, height: 70)
                            
                            VStack(spacing: 4) {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow.opacity(0.8))
                                    .font(.system(size: 18))
                                
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.blue.opacity(0.6))
                                    .font(.system(size: 12))
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Choose Commander")
                                .font(.system(size: 16, weight: .semibold, design: .serif))
                                .foregroundColor(.lightGrayText)
                            
                            Text("Search legendary creatures")
                                .font(.system(size: 12, weight: .medium, design: .serif))
                                .foregroundColor(.mutedSilverText)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue.opacity(0.6))
                            .font(.system(size: 14, weight: .medium))
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.oceanBlueBackground.opacity(0.4),
                                        Color.darkNavyBackground.opacity(0.6)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.yellow.opacity(0.3), Color.blue.opacity(0.2)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1.5
                                    )
                            )
                    )
                }
                .buttonStyle(MTGButtonStyle())
            }
            
            // Commander background toggle (only show if commander is selected)
            if player.commanderName != nil && !player.commanderName!.isEmpty {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Use Commander as Background")
                            .font(.system(size: 14, weight: .semibold, design: .serif))
                            .foregroundColor(.lightGrayText)
                        
                        Text("Display commander artwork behind player area")
                            .font(.system(size: 12, design: .serif))
                            .foregroundColor(.mutedSilverText)
                    }
                    
                    Spacer()
                    
                    Toggle("", isOn: $player.useCommanderAsBackground)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .scaleEffect(0.8)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.darkNavyBackground.opacity(0.4))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                        )
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.oceanBlueBackground.opacity(0.3))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.4), Color.purple.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .frame(maxWidth: isLandscape && !isIPad ? nil : .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // Helper method to get mana color
    private func manaColor(for colorSymbol: String) -> Color {
        switch colorSymbol.uppercased() {
        case "W":
            return Color(hex: "F8F6E8") // White
        case "U":
            return Color(hex: "4A90E2") // Blue
        case "B":
            return Color(hex: "1C1C1E") // Black
        case "R":
            return Color(hex: "D32F2F") // Red
        case "G":
            return Color(hex: "388E3C") // Green
        default:
            return Color(hex: "A0AEC0") // Colorless/Generic
        }
    }

    // MTG-themed button section
    private func mtgButtonSection() -> some View {
        HStack(spacing: buttonSpacing) {
            // Cancel Button (Counterspell style)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "xmark.shield.fill")
                        .font(.system(size: 16, weight: .medium))
                    Text("Dismiss")
                        .font(.system(size: isIPad ? 20 : 16, weight: .semibold, design: .serif))
                }
                .foregroundColor(.white)
                .frame(minWidth: buttonWidth)
                .padding(.vertical, buttonVerticalPadding)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.7), Color.gray.opacity(0.5)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .buttonStyle(MTGButtonStyle())
            
            // Save Button (Enchantment style)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if !playerName.isEmpty {
                        player.name = playerName
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 16, weight: .medium))
                    Text("Bind Identity")
                        .font(.system(size: isIPad ? 20 : 16, weight: .semibold, design: .serif))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, buttonVerticalPadding)
                .foregroundColor(.white)
                .frame(minWidth: buttonWidth)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.green.opacity(0.8), Color.green.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        )
                )
                .shadow(color: Color.green.opacity(0.4), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(MTGButtonStyle())
        }
        .padding(.vertical, isIPad ? 20 : 10)
        .frame(maxWidth: isLandscape && !isIPad ? nil : .infinity, alignment: .center)
    }
}

struct EditPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // iPhone - Portrait
            EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
                .previewDevice("iPhone 14")
                .previewDisplayName("iPhone (Portrait)")
            
            // iPhone - Landscape
            EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
                .previewDevice("iPhone 14")
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPhone (Landscape)")
            
            // iPhone - Dark mode
            EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
                .previewDevice("iPhone 14")
                .environment(\.colorScheme, .dark)
                .previewDisplayName("iPhone (Dark)")
            
            // iPad - Portrait
            EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
                .previewDevice("iPad Pro (11-inch)")
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .regular)
                .previewDisplayName("iPad (Portrait)")
            
            // iPad - Landscape
            EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
                .previewDevice("iPad Pro (11-inch)")
                .environment(\.horizontalSizeClass, .regular)
                .environment(\.verticalSizeClass, .regular)
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("iPad (Landscape)")
        }
    }
}

#Preview {
    EditPlayerView(player: .constant(Player(HP: 40, name: "Vinicius")))
}
