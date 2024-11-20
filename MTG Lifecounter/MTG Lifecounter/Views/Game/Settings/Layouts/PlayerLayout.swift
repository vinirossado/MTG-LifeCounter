//
//  PlayerLayout.swift
//  MTG Lifecounter
//
//  Created by Snowye on 20/11/24.
//

import SwiftUI

enum PlayerLayouts {
    case two
    case threeLeft
    case threeRight
    case four
    case five
    case six
}

struct PlayerLayout: View {
    let isSelected: Bool
    let onClick: () -> Void
    let players: PlayerLayouts
    
    var body: some View {
            
        let grid: AnyView = {
            switch players {
            case .two:
                return AnyView(TwoPlayerGridView())
            case .threeLeft:
                return AnyView(ThreePlayerLeftGridView())
            case .threeRight:
                return AnyView(ThreePlayerRightGridView())
            case .four:
                return AnyView(FourPlayerGridView())
            case .five:
                return AnyView(FivePlayerGridView())
            case .six:
                return AnyView(SixPlayerGridView())
            }
        }()
        
        VStack {
            ZStack {
                Rectangle()
                    .fill(Color.clear)
                    .aspectRatio(3 / 2, contentMode: .fit)
                    .overlay(grid)
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Color.white : Color.clear,
                        lineWidth: 2
                    )
            )
            .onTapGesture {
                onClick()
            }
        }
        .contentShape(Rectangle())
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
}

#Preview {
    @Previewable @State var selected: PlayerLayouts = .two;

    VStack {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
            PlayerLayout(isSelected: selected == .two, onClick: {
                selected = .two
            }, players: .two)
            PlayerLayout(isSelected: selected == .threeLeft, onClick: {
                selected = .threeLeft
            }, players: .threeLeft)
            PlayerLayout(isSelected: selected == .threeRight, onClick: {
                selected = .threeRight
            }, players: .threeRight)
            PlayerLayout(isSelected: selected == .four, onClick: {
                selected = .four
            }, players: .four)
            PlayerLayout(isSelected: selected == .five, onClick: {
                selected = .five
            }, players: .five)
            PlayerLayout(isSelected: selected == .six, onClick: {
                selected = .six
            }, players: .six)
        }
        
        Spacer()
    }
    .padding(.horizontal, 100)
}
