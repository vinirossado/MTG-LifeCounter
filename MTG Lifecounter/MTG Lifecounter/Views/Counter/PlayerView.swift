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
    @State var isHover = false
    
    
    struct Item: Identifiable {
        let id = UUID()
        var startingPoint: Int
        var backgroundColor: Color
    }
    
    init(lifeTotal: Binding<Int>, playerImage: String, size: CGFloat) {
        self._lifeTotal = lifeTotal
        self.playerImage = playerImage
        self.size = size
        self.imageId = Int.random(in: 1...1000)
    }
    
    @State private var items: [Item] = (1...6).map {_ in Item(startingPoint: 40, backgroundColor: Color.mint.opacity(0.2)) }
    @State private var opacities: [[Double]] = Array(repeating: [1.0, 1.0], count: 6)
    @State private var isPressed: Bool = false;
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
        
        return LazyVGrid(columns: columns, spacing: 10) {
            
            
            ForEach(items.indices, id: \.self) { index in
                HStack(spacing: 0) {
                    HStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(items[index].backgroundColor)
                            .opacity(isPressed ? 0.75: opacities[index][0] )
                            .onTapGesture {
                                changeOpacity(at: index, side: 0)
                                updatePoints(at: index, side: 0,  amount: 1)
                            }
                            .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0.2, pressing: { pressing in
                                withAnimation{
                                    isPressed = pressing
                                }
                                print("long pressing left")
                            },perform: {
                                updatePoints(at: index, side: 0, amount: 10)
                            })
                    }
                    
                    HStack {
                        Rectangle()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(items[index].backgroundColor)
                            .opacity(opacities[index][1])
                            .onTapGesture {
                                changeOpacity(at: index, side: 1)
                                updatePoints(at: index, side: 1, amount: 1)
                            }
                            .onLongPressGesture(minimumDuration: 0.1, maximumDistance: 0.2) {
                                changeOpacity(at: index, side: 1)
                                updatePoints(at: index, side: 1, amount: 10)
                                print("long pressing right")
                            }
                    }
                }
                .frame(width: isPortrait ? (geometry.size.width - 30) / 2 : (geometry.size.width - 50) / 3,
                       height: (geometry.size.height - 30) / (isPortrait ? 3 : 2))
                .cornerRadius(8)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .overlay(Text("40").frame(maxWidth: .infinity), alignment: .center)
                .foregroundColor(.red)
                .font(.system(size: 24))

            }
        }
        //
        
    }
    
    func changeOpacity(at index: Int, side: Int) {
        if index < opacities.count {
            opacities[index][side] = 0.75
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if index < self.opacities.count {
                    self.opacities[index][side] = 1.0
                }
            }
        }
    }
    
    func updatePoints(at index: Int, side: Int, amount: Int) {
        if index < items.count {
            if side == 0 {
                items[index].startingPoint -= amount
            } else {
                items[index].startingPoint += amount
            }
        }
    }}

#Preview {
    PlayerView(lifeTotal: .constant(20), playerImage: "player1", size: 200)
}

