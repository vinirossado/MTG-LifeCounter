//
//  MTG_LifecounterApp.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI
import SwiftData

@main
struct MTG_LifecounterApp: App {
    @StateObject private var gameSettings = GameSettings()
    @StateObject private var playerState = PlayerState()
    @StateObject private var screenWakeManager = ScreenWakeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .environmentObject(gameSettings)
                .environmentObject(playerState)
                .environmentObject(screenWakeManager)
        }
    }
}
