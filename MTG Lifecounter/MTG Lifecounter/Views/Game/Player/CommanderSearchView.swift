//
//  CommanderSearchView.swift
//  MTG Lifecounter
//
//  Created by Assistant on 26.06.2025.
//

import SwiftUI

// MARK: - Commander Search View
struct CommanderSearchView: View {
    @Binding var player: Player
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @StateObject private var viewModel = CommanderSelectionViewModel()
    @State private var selectedCommander: ScryfallCard?
    @State private var showingDetail = false
    
    // Dynamic sizing
    private var isIPad: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var isLandscape: Bool {
        verticalSizeClass == .compact
    }
    
    private var titleFontSize: CGFloat {
        if isIPad { return 32 }
        return isLandscape ? 24 : 28
    }
    
    private var gridColumns: [GridItem] {
        let count = isIPad ? 3 : (isLandscape ? 3 : 2)
        return Array(repeating: GridItem(.flexible(), spacing: 8), count: count)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Mystical background
                LinearGradient(
                    colors: [
                        Color.darkNavyBackground,
                        Color.oceanBlueBackground.opacity(0.8),
                        Color.darkNavyBackground
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: isIPad ? 24 : 16) {
                        // Header
                        MTGHeaderView(title: "Choose Your Commander")
                        
                        // Search Section
                        searchSection
                        
                        // Results Section
                        if viewModel.isSearching {
                            loadingSection
                        } else if !viewModel.searchText.isEmpty && !viewModel.searchResults.isEmpty {
                            searchResultsSection
                        } else if !viewModel.searchText.isEmpty && viewModel.searchResults.isEmpty {
                            noResultsSection
                        } else {
                            featuredSection
                        }
                        
                        // Error Message
                        if let errorMessage = viewModel.errorMessage {
                            ErrorMessageView(message: errorMessage)
                        }
                    }
                    .padding(isIPad ? 24 : 16)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .onAppear {
                // Clear any existing error when view appears
                viewModel.errorMessage = nil
            }
            .sheet(isPresented: $showingDetail) {
                if let commander = selectedCommander {
                    CommanderDetailView(
                        commander: commander,
                        onSelect: { selectedCard in
                            selectCommander(selectedCard, useAsBackground: false)
                        },
                        onSelectAsBackground: { selectedCard in
                            selectCommander(selectedCard, useAsBackground: true)
                        }
                    )
                }
            }
        }
    }
    
    // MARK: - Search Section
    private var searchSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.blue.opacity(0.7))
                    .font(.system(size: 18))
                Text("Search Commanders")
                    .font(.system(size: 18, weight: .semibold, design: .serif))
                    .foregroundColor(.lightGrayText)
            }
            
            HStack(spacing: 12) {
                // Search Field
                TextField("Enter commander name...", text: $viewModel.searchText)
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.oceanBlueBackground.opacity(0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    )
                    .foregroundColor(.lightGrayText)
                    .onSubmit {
                        viewModel.searchCommanders()
                    }
                
                // Search Button
                Button(action: {
                    viewModel.searchCommanders()
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(
                                    colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                }
                .disabled(viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).count < 2)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkNavyBackground.opacity(0.6))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Search Results Section
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Search Results")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.lightGrayText)
                Spacer()
                Text("\(viewModel.searchResults.count) found")
                    .font(.system(size: 14, design: .serif))
                    .foregroundColor(.mutedSilverText)
            }
            
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(viewModel.searchResults) { commander in
                    CommanderCardView(commander: commander) {
                        selectedCommander = commander
                        showingDetail = true
                    }
                }
            }
        }
    }
    
    // MARK: - Featured Section
    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow.opacity(0.8))
                    .font(.system(size: 16))
                Text("Popular Commanders")
                    .font(.system(size: 20, weight: .bold, design: .serif))
                    .foregroundColor(.lightGrayText)
            }
            
            if viewModel.featuredCommanders.isEmpty {
                loadingSection
            } else {
                LazyVGrid(columns: gridColumns, spacing: 12) {
                    ForEach(viewModel.featuredCommanders.prefix(12)) { commander in
                        CommanderCardView(commander: commander) {
                            selectedCommander = commander
                            showingDetail = true
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Loading Section
    private var loadingSection: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.2)
            
            Text("Searching the multiverse...")
                .font(.system(size: 16, design: .serif))
                .foregroundColor(.mutedSilverText)
                .italic()
        }
        .frame(maxWidth: .infinity, minHeight: 120)
    }
    
    // MARK: - No Results Section
    private var noResultsSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(.mutedSilverText.opacity(0.6))
            
            Text("No commanders found")
                .font(.system(size: 18, weight: .semibold, design: .serif))
                .foregroundColor(.lightGrayText)
            
            Text("Try a different search term or browse popular commanders below")
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.mutedSilverText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 120)
    }
    
    // MARK: - Helper Methods
    private func selectCommander(_ commander: ScryfallCard, useAsBackground: Bool = false) {
        player.commanderName = commander.name
        player.commanderImageURL = commander.imageURL
        player.commanderArtworkURL = commander.artworkURL
        player.commanderColors = commander.displayColors
        player.commanderTypeLine = commander.type_line
        player.useCommanderAsBackground = useAsBackground
        
        presentationMode.wrappedValue.dismiss()
    }
}

// MARK: - Commander Card View
struct CommanderCardView: View {
    let commander: ScryfallCard
    let onTap: () -> Void
    
    @State private var imageLoaded = false
    @State private var imageError = false
    
    var body: some View {
        VStack(spacing: 8) {
            // Card Image
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [
                            Color.darkNavyBackground,
                            Color.oceanBlueBackground.opacity(0.8)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 160)
                
                if let imageURL = commander.imageURL, !imageError {
                    AsyncImage(url: URL(string: imageURL)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 160)
                                .cornerRadius(12)
                                .onAppear {
                                    imageLoaded = true
                                    print("✅ Image loaded successfully: \(imageURL)")
                                }
                        case .failure(let error):
                            VStack(spacing: 4) {
                                Image(systemName: "exclamationmark.triangle")
                                    .font(.system(size: 24))
                                    .foregroundColor(.orange)
                                Text("Failed to load")
                                    .font(.caption)
                                    .foregroundColor(.mutedSilverText)
                            }
                            .onAppear {
                                imageError = true
                                print("❌ Image failed to load: \(imageURL) - Error: \(error.localizedDescription)")
                            }
                        case .empty:
                            VStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                Text("Loading...")
                                    .font(.caption)
                                    .foregroundColor(.mutedSilverText)
                            }
                            .onAppear {
                                print("🔄 Loading image: \(imageURL)")
                            }
                        @unknown default:
                            VStack(spacing: 8) {
                                Image(systemName: "person.fill.questionmark")
                                    .font(.system(size: 32))
                                    .foregroundColor(.mutedSilverText)
                                
                                Text("Unknown State")
                                    .font(.caption)
                                    .foregroundColor(.mutedSilverText)
                            }
                        }
                    }
                    .onAppear {
                        imageError = false
                    }
                } else {
                    VStack(spacing: 8) {
                        Image(systemName: "person.fill.questionmark")
                            .font(.system(size: 32))
                            .foregroundColor(.mutedSilverText)
                        
                        Text("No Image")
                            .font(.caption)
                            .foregroundColor(.mutedSilverText)
                    }
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
            )
            
            // Commander Info
            VStack(spacing: 4) {
                Text(commander.name)
                    .font(.system(size: 14, weight: .semibold, design: .serif))
                    .foregroundColor(.lightGrayText)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .padding(.vertical ,MTGSpacing.sm)
                
                // Mana Colors
//                if !commander.displayColors.isEmpty {
//                    ManaColorsView(colors: commander.displayColors)
//                }
                
//                Text(commander.type_line)
//                    .font(.system(size: 10, design: .serif))
//                    .foregroundColor(.mutedSilverText)
//                    .multilineTextAlignment(.center)
//                    .lineLimit(2)
            }
        }
        .onTapGesture {
            onTap()
        }
        .contentShape(Rectangle())
    }
}

// MARK: - Mana Colors View
struct ManaColorsView: View {
    let colors: [String]
    
    private let manaColorMap: [String: (Color, String)] = [
        "W": (Color.yellow, "W"),
        "U": (Color.blue, "U"),
        "B": (Color.black, "B"),
        "R": (Color.red, "R"),
        "G": (Color.green, "G")
    ]
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(colors, id: \.self) { color in
                if let (bgColor, symbol) = manaColorMap[color] {
                    Text(symbol)
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        .background(
                            Circle()
                                .fill(bgColor)
                                .overlay(
                                    Circle()
                                        .stroke(Color.white.opacity(0.3), lineWidth: 0.5)
                                )
                        )
                }
            }
        }
    }
}

// MARK: - Header View
struct MTGHeaderView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 12) {
            // Decorative header
            HStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 8, height: 8)
                
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 1)
                
                Text("⚔️")
                    .font(.system(size: 14))
                
                Rectangle()
                    .fill(LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .frame(height: 1)
                
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.purple.opacity(0.6), Color.blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 8, height: 8)
            }
            
            Text(title)
                .font(.system(size: 28, weight: .bold, design: .serif))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.white, Color.lightGrayText],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.blue.opacity(0.3), radius: 2, x: 0, y: 1)
        }
    }
}

// MARK: - Error Message View
struct ErrorMessageView: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)
                .font(.system(size: 16))
            
            Text(message)
                .font(.system(size: 14, design: .serif))
                .foregroundColor(.lightGrayText)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.orange.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Preview
#Preview {
    CommanderSearchView(player: .constant(Player(HP: 40, name: "Test Player")))
}
