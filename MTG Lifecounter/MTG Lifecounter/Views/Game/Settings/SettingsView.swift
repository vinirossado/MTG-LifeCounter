//
//  SettingsView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 19/11/24.
//

import SwiftUI

struct SettingsView: View {
//    @State private var manager = DeviceOrientationManager.shared
    @State private var selected: PlayerLayouts = .two
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Settings")
                .font(.system(size: 30, weight: .bold))
                .padding(.bottom, 32)
            
            Text("Players")
                .font(.system(size: 24, weight: .semibold))
                .padding(.bottom, 16)
                
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
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
                
                LifePointsView()
            }
        }
        .frame(
            width: UIScreen.main.bounds.width - 256,
            height: UIScreen.main.bounds.height,
            alignment: .top
        )
        .padding(.horizontal, 128)
        .padding(.top, 64)
    }
}

#Preview {
    SettingsView()
}

