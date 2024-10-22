//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI

struct Style {
    var background: Color
    var opacity: Double
    var hoverOpacity: Double
}

let DEFAULT_STYLES = Style(
    background: Color.mint,
    opacity: 1,
    hoverOpacity: 0.75
)

struct PlayerView: View {
    @Binding var lifeTotal: Int
    
    let playerImage: String
    let size: CGFloat
    
    @State private var items: [Item] = (1...6).map { _ in Item(startingPoint: 40) }
    
    struct Item: Identifiable {
        let id = UUID()
        var startingPoint: Int
    }
    
    var body: some View {
        GeometryReader { geometry in
            generateItems(count: 4, geometry: geometry)
                .padding(10)
                .edgesIgnoringSafeArea(.trailing)
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }
    
    func generateItems(count: Int, geometry: GeometryProxy) -> some View {
        let isPortrait = geometry.size.height > geometry.size.width
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: isPortrait ? 2 : 3)
        let itemWidth = isPortrait ? (geometry.size.width - 30) / 2 : (geometry.size.width - 50) / 3
        let itemHeight = (geometry.size.height - 30) / (isPortrait ? 3 : 2)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                PlayerTileView(startingPoint: $items[index].startingPoint)
                    .frame(width: itemWidth, height: itemHeight)
            }
        }
    }
}


struct PlayerTileView: View {
    @Binding var startingPoint: Int
    
    @State private var isLeftPressed: Bool = false
    @State private var isRightPressed: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            HStack {
                Rectangle()
                    .fill(Color.mint.opacity(0.2)) // Mint background with 0.20 opacity
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(isLeftPressed ? DEFAULT_STYLES.hoverOpacity : DEFAULT_STYLES.opacity)
                    .onTapGesture {
                        updatePoints(side: 0, amount: 1)
                    }
                    .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0.2, pressing: { pressing in
                        withAnimation {
                            isLeftPressed = pressing
                        }
                    }, perform: {
                        updatePoints(side: 0, amount: 10)
                    })
            }
            
            HStack {
                Rectangle()
                    .fill(Color.mint.opacity(0.2)) // Mint background with 0.20 opacity
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(isRightPressed ? DEFAULT_STYLES.hoverOpacity : DEFAULT_STYLES.opacity)
                    .onTapGesture {
                        updatePoints(side: 1, amount: 1)
                    }
                    .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0.2, pressing: { pressing in
                        withAnimation {
                            isRightPressed = pressing
                        }
                    }, perform: {
                        updatePoints(side: 1, amount: 10)
                    })
            }
        }
        .cornerRadius(16)
        .overlay(
            Text("\(startingPoint)")
                .frame(maxWidth: .infinity), alignment: .center)
        .foregroundColor(.white) // Set text color to white for contrast
        .font(.system(size: 24))
    }
    
    private func updatePoints(side: Int, amount: Int) {
        if side == 0 {
            startingPoint -= amount
        } else {
            startingPoint += amount
        }
    }
}


#Preview {
    PlayerView(lifeTotal: .constant(20), playerImage: "player1", size: 200)
}

