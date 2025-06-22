# Screen Wake Management - Implementation Summary

## Issue Fixed
The MTG Lifecounter app was experiencing screen timeout issues where:
1. The screen would go dark after some time during gameplay
2. When switching between apps and returning, the screen would timeout very quickly
3. The app should keep the screen awake during gameplay to prevent interruptions

## Solution Implemented

### 1. ScreenWakeManager.swift
- **Location**: `Utils/ScreenWakeManager.swift`
- **Purpose**: Centralized management of screen wake state and app lifecycle handling
- **Key Features**:
  - Uses `UIApplication.shared.isIdleTimerDisabled` to control screen sleep
  - Handles app lifecycle events (foreground/background transitions)
  - Automatically re-enables screen wake when returning from background
  - Provides debug logging for troubleshooting
  - Thread-safe implementation with proper state management

### 2. App Integration
- **MTG_LifecounterApp.swift**: Added `ScreenWakeManager` as a `@StateObject` and injected into environment
- **GameView.swift**: 
  - Added `@EnvironmentObject var screenWakeManager: ScreenWakeManager`
  - Enabled screen wake on `onAppear` (when entering game)
  - Disabled screen wake on `onDisappear` (when leaving game)
- **ContentView.swift**: 
  - Added environment object reference
  - Disabled screen wake on home screen to allow normal behavior

### 3. Settings UI
- **SettingsPanelView.swift**: Added new "Screen Control" section
- **MTGScreenWakeToggle**: Custom toggle component with MTG styling
  - Shows current screen wake status
  - Allows manual toggle control
  - Provides visual feedback with mystical MTG theming
  - Includes haptic feedback for better UX

## How It Works

1. **During Gameplay**: Screen wake is automatically enabled when entering `GameView`
2. **App Switching**: When user switches to another app and returns, screen wake is re-enabled automatically
3. **Home Screen**: Screen wake is disabled to allow normal device sleep behavior
4. **Manual Control**: Users can toggle screen wake manually in settings

## App Lifecycle Handling

The `ScreenWakeManager` monitors these iOS notifications:
- `UIApplication.didBecomeActiveNotification`: Re-enables screen wake if game was active
- `UIApplication.willResignActiveNotification`: Prepares for background state
- `UIApplication.didEnterBackgroundNotification`: Temporarily disables screen wake
- `UIApplication.willEnterForegroundNotification`: Prepares to re-enable screen wake

## Benefits

1. **Uninterrupted Gameplay**: Screen stays awake during games
2. **Battery Efficiency**: Screen wake only active during gameplay
3. **Seamless App Switching**: Automatically handles foreground/background transitions
4. **User Control**: Optional manual toggle in settings
5. **Proper Cleanup**: Ensures screen wake is disabled when leaving the app

## Testing

To test the implementation:
1. Start a game and verify screen doesn't sleep during gameplay
2. Switch to another app and return - screen should stay awake
3. Go back to home screen - screen should be able to sleep normally
4. Toggle the setting in Settings panel to verify manual control works
5. Check debug console for screen wake state messages

## Debug Information

The implementation includes debug logging (only in DEBUG builds) that shows:
- When screen wake is enabled/disabled
- App lifecycle transitions
- Current screen wake state

This helps troubleshoot any issues with screen management behavior.
