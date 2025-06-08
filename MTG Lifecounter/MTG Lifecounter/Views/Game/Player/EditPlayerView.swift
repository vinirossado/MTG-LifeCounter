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
                backgroundColor.edgesIgnoringSafeArea(.all)
                
                // Content container with responsiveness
                ScrollView {
                    VStack(alignment: .center, spacing: isIPad ? 30 : 20) {
                        // Title at the top
                        Text("Customize Player")
                            .font(.system(size: titleFontSize, weight: .bold, design: .rounded))
                            .foregroundColor(textColor)
                            .padding(.top, verticalPadding)
                            .padding(.bottom, isIPad ? 20 : 10)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Adaptive layout for landscape mode
                        if isLandscape {
                            // Landscape layout
                            HStack(alignment: .top, spacing: 20) {
                                // Input field section
                                playerInputSection()
                                
                                // Button section
                                buttonSection()
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.bottom, verticalPadding)
                        } else {
                            // Portrait layout
                            VStack(spacing: isIPad ? 40 : 30) {
                                // Input field section
                                playerInputSection()
                                
                                Spacer(minLength: isIPad ? 40 : 20)
                                
                                // Button section
                                buttonSection()
                            }
                            .padding(.horizontal, horizontalPadding)
                            .padding(.bottom, verticalPadding)
                            .frame(minHeight: geometry.size.height * 0.7)
                        }
                    }
                    .frame(minHeight: geometry.size.height)
                }
                .onAppear {
                    viewHeight = geometry.size.height
                    // Initialize with current player name
                    playerName = player.name
                    
                    // Set initial orientation
                    updateOrientation()
                }
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    updateOrientation()
                }
            }
        }
    }
    
    // Helper method to track orientation changes
    private func updateOrientation() {
        orientation = UIDevice.current.orientation
    }
    
    // Player input section
    private func playerInputSection() -> some View {
        VStack(alignment: .leading, spacing: isIPad ? 12 : 8) {
            Text("Player Name")
                .font(.system(size: labelFontSize, weight: .semibold))
                .foregroundColor(textColor.opacity(0.8))
                .padding(.leading, 4)
            
            TextField("", text: Binding(
                get: { self.playerName.isEmpty ? self.player.name : self.playerName },
                set: { self.playerName = $0 }
            ))
            .font(.system(size: inputFontSize, weight: .medium))
            .padding(.vertical, isIPad ? 16 : 14)
            .padding(.horizontal, isIPad ? 20 : 16)
            .background(
                RoundedRectangle(cornerRadius: isIPad ? 16 : 12)
                    .fill(colorScheme == .dark ? Color.oceanBlueBackground : Color(UIColor.tertiarySystemBackground))
                    .shadow(color: colorScheme == .dark ? Color.black.opacity(0.25) : Color.gray.opacity(0.15), radius: isIPad ? 5 : 3, x: 0, y: 2)
            )
            .foregroundColor(textColor)
            .autocapitalization(.words)
        }
        .frame(maxWidth: isLandscape && !isIPad ? nil : .infinity)
        .fixedSize(horizontal: false, vertical: true)
    }
    
    // Button section
    private func buttonSection() -> some View {
        HStack(spacing: buttonSpacing) {
            // Cancel Button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.system(size: isIPad ? 20 : 16, weight: .semibold))
                    .frame(minWidth: buttonWidth)
                    .padding(.vertical, buttonVerticalPadding)
                    .background(
                        Capsule()
                            .fill(Color(hex: "E53935"))
                            .shadow(color: Color.black.opacity(0.2), radius: isIPad ? 6 : 4, x: 0, y: 2)
                    )
                    .foregroundColor(.white)
            }
            
            // Save Button
            Button(action: {
                if !playerName.isEmpty {
                    player.name = playerName
                }
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Save")
                    .font(.system(size: isIPad ? 20 : 16, weight: .semibold))
                    .frame(minWidth: buttonWidth)
                    .padding(.vertical, buttonVerticalPadding)
                    .background(
                        Capsule()
                            .fill(Color(hex: "4CAF50"))
                            .shadow(color: Color.black.opacity(0.2), radius: isIPad ? 6 : 4, x: 0, y: 2)
                    )
                    .foregroundColor(.white)
            }
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
