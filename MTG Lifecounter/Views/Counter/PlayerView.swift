//
//  PlayerView.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI

struct PlayerView: View {
    @Binding var lifeTotal: Int
    
    let playerImage: String
    let size: CGFloat
    let imageId: Int
    
    let choosenStartingPoints: Int = 40
    
    @State private var backgroundColor = Color.gray
    @State private var isPressed = false
    @State private var opacity = 1
    
    struct Item: Identifiable {
        let id = UUID()
        var startingPoint: Int
        var backgroundColor: Color
        var opacity: Double

    }
    
    init(lifeTotal: Binding<Int>, playerImage: String, size: CGFloat) {
        self._lifeTotal = lifeTotal
        self.playerImage = playerImage
        self.size = size
        self.imageId = Int.random(in: 1...1000)
    }
    
    
    var body: some View {
        GeometryReader { geometry in
            generateItems(count: 6, geometry: geometry)
                .padding(10)
                .edgesIgnoringSafeArea(.trailing)
                .onAppear {
                    // Prevent the screen from turning off
                    UIApplication.shared.isIdleTimerDisabled = true
                }
                .onDisappear {
                    // Allow the screen to turn off again when the view disappears
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            
            
        }
    }
    
    @State private var items: [Item] = (1...6).map {_ in Item(startingPoint: 40, backgroundColor: Color.gray, opacity: 1 ) }
    
    func generateItems(count: Int, geometry: GeometryProxy) -> some View {
        
        let isPortrait = geometry.size.height > geometry.size.width
        let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 10), count: isPortrait ? 2 : 3)
        
        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(items.indices, id: \.self) { index in
                Text("\(items[index].startingPoint)")
                    .frame(width: isPortrait ? (geometry.size.width - 30) / 2 : (geometry.size.width - 50) / 3,
                           height: (geometry.size.height - 30) / (isPortrait ? 3 : 2))
                    .background(items[index].backgroundColor)
                    .opacity(Double(items[index].opacity))
                    .cornerRadius(8)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .onTapGesture {
                        changeColor(at: index)
                        changeItem(at: index)
                    }
                    .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0.2) {
                        increasePoints(at: index, amount: 10)
                        changeColor(at: index)
                        print("long pressing")
                    }
            }
        }
        
        func changeItem(at index: Int) {
            if index < items.count {
                items[index].startingPoint += 1
            }
        }
        
        func changeColor(at index: Int) {
                if index < items.count {
                    self.items[index].opacity = 0.7
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        if index < self.items.count {
                            self.items[index].opacity = 1
                        }
                    }
                }
            }
        
        func increasePoints(at index: Int, amount: Int) {
            if index < items.count {
                items[index].startingPoint += amount
            }
        }
        
        func decreasePoints(at index: Int) {
            if index < items.count {
                items[index].startingPoint += 1
            }
        }
        
    }
}

#Preview {
    PlayerView(lifeTotal: .constant(20), playerImage: "player1", size: 200)
}

