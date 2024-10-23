//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI

struct GameView: View {
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
                PlayerView(playerHP: $items[index].startingPoint)
                    .frame(width: itemWidth, height: itemHeight)
            }
        }
    }
}

#Preview {
    GameView(lifeTotal: .constant(40), playerImage: "", size: 200)
}

