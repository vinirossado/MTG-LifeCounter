//
//  SettingsView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 19/11/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var gameSettings: GameSettings

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
                    PlayerLayout(isSelected: gameSettings.layout == .two, onClick: {
                        gameSettings.layout = .two
                    }, players: .two)
                    PlayerLayout(isSelected: gameSettings.layout == .threeLeft, onClick: {
                        gameSettings.layout = .threeLeft
                    }, players: .threeLeft)
                    PlayerLayout(isSelected: gameSettings.layout == .threeRight, onClick: {
                        gameSettings.layout = .threeRight
                    }, players: .threeRight)
                    PlayerLayout(isSelected: gameSettings.layout == .four, onClick: {
                        gameSettings.layout = .four
                    }, players: .four)
                    PlayerLayout(isSelected: gameSettings.layout == .five, onClick: {
                        gameSettings.layout = .five
                    }, players: .five)
                    PlayerLayout(isSelected: gameSettings.layout == .six, onClick: {
                        gameSettings.layout = .six
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
        .environmentObject(GameSettings())
}

