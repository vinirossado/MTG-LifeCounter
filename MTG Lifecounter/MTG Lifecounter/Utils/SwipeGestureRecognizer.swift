import UIKit
import SwiftUI

/// Custom gesture recognizer for detecting single-finger swipes
class SwipeGestureRecognizer: UIGestureRecognizer {
    
    // MARK: - Properties
    private var initialTouch: UITouch?
    private var currentTouch: UITouch?
    
    // Gesture configuration
    private let minimumDistance: CGFloat = 30
    
    // Callback for gesture recognition
    var onGestureRecognized: ((CGPoint, CGVector, CGFloat) -> Void)?
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        // We want exactly 1 touch
        if touches.count == 1 {
            initialTouch = touch
            currentTouch = touch
            state = .began
        } else {
            // If not exactly 1 touch, fail immediately to let other gestures work
            state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state == .began || state == .changed,
              let touch = touches.first,
              touch == initialTouch else {
            state = .failed
            return
        }
        
        currentTouch = touch
        
        // Check if the gesture is valid
        if isValidSwipe() {
            state = .changed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
              touch == initialTouch else {
            state = .failed
            return
        }
        
        // If we still have the same touch and the gesture was valid
        if (state == .began || state == .changed) && isValidSwipe() {
            state = .ended
            recognizeGesture()
        } else {
            state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .cancelled
    }
    
    // MARK: - Gesture Validation
    
    private func isValidSwipe() -> Bool {
        guard let initialTouch = initialTouch,
              let currentTouch = currentTouch,
              let view = view else { return false }
        
        // Get initial and current positions
        let initialPosition = initialTouch.location(in: view)
        let currentPosition = currentTouch.location(in: view)
        
        // Calculate movement vector
        let movement = CGVector(
            dx: currentPosition.x - initialPosition.x,
            dy: currentPosition.y - initialPosition.y
        )
        
        // Calculate distance moved
        let distance = sqrt(movement.dx * movement.dx + movement.dy * movement.dy)
        
        // Check if finger moved minimum distance
        return distance >= minimumDistance
    }
    
    private func recognizeGesture() {
        guard let initialTouch = initialTouch,
              let currentTouch = currentTouch,
              let view = view else { return }
        
        // Calculate the movement
        let initialPosition = initialTouch.location(in: view)
        let currentPosition = currentTouch.location(in: view)
        
        let movement = CGVector(
            dx: currentPosition.x - initialPosition.x,
            dy: currentPosition.y - initialPosition.y
        )
        
        let distance = sqrt(movement.dx * movement.dx + movement.dy * movement.dy)
        
        // Add haptic feedback for successful gesture
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Call the callback with the initial position as the gesture location
        onGestureRecognized?(initialPosition, movement, distance)
    }
    
    // MARK: - Reset
    
    override func reset() {
        super.reset()
        initialTouch = nil
        currentTouch = nil
    }
}

/// SwiftUI wrapper for the single-finger swipe gesture
struct SwipeGesture: UIViewRepresentable {
    let onSwipe: (CGPoint, CGVector, CGFloat) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        
        let gestureRecognizer = SwipeGestureRecognizer()
        gestureRecognizer.onGestureRecognized = onSwipe
        
        // Allow simultaneous recognition with other gestures
        gestureRecognizer.delegate = context.coordinator
        
        view.addGestureRecognizer(gestureRecognizer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            // Allow simultaneous recognition with other gestures
            return true
        }
        
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldReceive touch: UITouch
        ) -> Bool {
            // Let all touches through - we'll handle the filtering in the gesture recognizer itself
            return true
        }
        
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            // Don't require other gestures to fail
            return false
        }
        
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            // Don't require to fail other gestures
            return false
        }
    }
}
