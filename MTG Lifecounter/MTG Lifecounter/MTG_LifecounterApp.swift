//
//  MTG_LifecounterApp.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 17.09.2024.
//

import SwiftUI
import SwiftData

// Landscape only app delegate handler
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // Only allow landscape orientations
        return .landscape
    }
}

@main
struct MTG_LifecounterApp: App {
    @StateObject private var gameSettings = GameSettings()
    @StateObject private var playerState = PlayerState()
    // Register app delegate for handling orientation
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .environmentObject(gameSettings)
                .environmentObject(playerState)
        }
    }
}
