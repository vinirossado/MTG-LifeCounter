//
//  ScreenWakeManager.swift
//  MTG Lifecounter
//
//  Created by Vinicius Rossado on 22.06.2025.
//

import UIKit
import SwiftUI

/// Manager class to handle screen wake state and prevent device from sleeping during gameplay
class ScreenWakeManager: ObservableObject {
    @Published private(set) var isScreenAwake: Bool = false
    
    private var isGameActive: Bool = false
    private var notificationObservers: [NSObjectProtocol] = []
    
    init() {
        setupNotificationObservers()
    }
    
    deinit {
        // Remove all notification observers
        notificationObservers.forEach { observer in
            NotificationCenter.default.removeObserver(observer)
        }
        
        // Ensure screen wake is disabled when manager is deallocated
        disableScreenWake()
    }
    
    // MARK: - Public Methods
    
    /// Enable screen wake to prevent device from sleeping
    func enableScreenWake() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true
            self.isScreenAwake = true
            self.isGameActive = true
        }
        
        #if DEBUG
        print("🔋 Screen wake ENABLED - Device will not sleep")
        #endif
    }
    
    /// Disable screen wake to allow normal device sleep behavior
    func disableScreenWake() {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
            self.isScreenAwake = false
            self.isGameActive = false
        }
        
        #if DEBUG
        print("🔋 Screen wake DISABLED - Device can sleep normally")
        #endif
    }
    
    /// Toggle screen wake state
    func toggleScreenWake() {
        if isScreenAwake {
            disableScreenWake()
        } else {
            enableScreenWake()
        }
    }
    
    // MARK: - App Lifecycle Handling
    
    private func setupNotificationObservers() {
        // App becomes active (foreground)
        let activeObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAppBecameActive()
        }
        notificationObservers.append(activeObserver)
        
        // App will resign active (background/inactive)
        let resignObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAppWillResignActive()
        }
        notificationObservers.append(resignObserver)
        
        // App enters background
        let backgroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.didEnterBackgroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAppEnteredBackground()
        }
        notificationObservers.append(backgroundObserver)
        
        // App will enter foreground
        let foregroundObserver = NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleAppWillEnterForeground()
        }
        notificationObservers.append(foregroundObserver)
    }
    
    private func handleAppBecameActive() {
        // Re-enable screen wake if game was active before app became inactive
        if isGameActive {
            DispatchQueue.main.async {
                UIApplication.shared.isIdleTimerDisabled = true
                self.isScreenAwake = true
            }
            
            #if DEBUG
            print("🔋 App became active - Screen wake re-enabled")
            #endif
        }
    }
    
    private func handleAppWillResignActive() {
        // Keep the game state but allow system to manage power
        // Don't change isGameActive here, just the actual timer state
        
        #if DEBUG
        print("🔋 App will resign active - Preparing for background")
        #endif
    }
    
    private func handleAppEnteredBackground() {
        // Allow device to sleep when app is in background
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false
            self.isScreenAwake = false
        }
        
        #if DEBUG
        print("🔋 App entered background - Screen wake temporarily disabled")
        #endif
    }
    
    private func handleAppWillEnterForeground() {
        // Prepare to re-enable screen wake when app returns to foreground
        
        #if DEBUG
        print("🔋 App will enter foreground - Preparing to re-enable screen wake")
        #endif
    }
}

// MARK: - SwiftUI View Extension for Screen Wake Management

extension View {
    /// Modifier to enable screen wake while this view is active
    /// - Parameter isEnabled: Whether screen wake should be enabled
    /// - Returns: Modified view with screen wake behavior
    func screenWake(_ isEnabled: Bool = true) -> some View {
        self.modifier(ScreenWakeModifier(isEnabled: isEnabled))
    }
}

// MARK: - Screen Wake View Modifier

private struct ScreenWakeModifier: ViewModifier {
    let isEnabled: Bool
    @StateObject private var screenWakeManager = ScreenWakeManager()
    
    func body(content: Content) -> some View {
        content
            .environmentObject(screenWakeManager)
            .onAppear {
                if isEnabled {
                    screenWakeManager.enableScreenWake()
                }
            }
            .onDisappear {
                if isEnabled {
                    screenWakeManager.disableScreenWake()
                }
            }
    }
}

// MARK: - Environment Key for Screen Wake Manager

private struct ScreenWakeManagerKey: EnvironmentKey {
    static let defaultValue: ScreenWakeManager? = nil
}

extension EnvironmentValues {
    var screenWakeManager: ScreenWakeManager? {
        get { self[ScreenWakeManagerKey.self] }
        set { self[ScreenWakeManagerKey.self] = newValue }
    }
}
