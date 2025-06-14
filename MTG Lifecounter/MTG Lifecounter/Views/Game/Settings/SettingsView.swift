//
//  SettingsView.swift
//  MTG Lifecounter
//
//  Created by Snowye on 19/11/24.
//

import SwiftUI

//struct SettingsView: View {
//  @EnvironmentObject var gameSettings: GameSettings
//
//  var body: some View {
//
//    VStack(alignment: .leading, spacing: 0) {
//      Text("Settings")
//        .font(.system(size: 30, weight: .bold))
//        .padding(.bottom, 32)
//
//      Text("Players")
//        .font(.system(size: 24, weight: .semibold))
//        .padding(.bottom, 16)
//
//      VStack {
//        // Using our reusable PlayerLayoutsGrid component
//        PlayerLayoutsGrid()
//          PlayerLayout(
//            isSelected: gameSettings.layout == .six,
//            onClick: {
//              gameSettings.layout = .six
//            }, players: .six)
//        }
//
//        LifePointsView()
//
//        // Add more settings here
//
//      }
//  }
////    .frame(
////      width: UIScreen.main.bounds.width - 256,
////      height: UIScreen.main.bounds.height,
////      alignment: .top
////    )
////    .padding(.horizontal, 128)
////    .padding(.top, 64)
//  }
//
//#Preview {
//  SettingsView()
//    .environmentObject(GameSettings())
//}
