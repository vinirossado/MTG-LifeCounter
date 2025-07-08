import UIKit
import SwiftUI

/// Custom gesture recognizer for detecting two-finger swipes
class TwoFingerSwipeGestureRecognizer: UIGestureRecognizer {
    
    // MARK: - Properties
    private var initialTouches: [UITouch] = []
    private var currentTouches: [UITouch] = []
    
    // Gesture configuration
    private let minimumDistance: CGFloat = 30
    private let maximumFingerSeparation: CGFloat = 100 // Max distance between fingers
    private let minimumParallelMovement: CGFloat = 0.7 // How parallel the movements should be (0-1)
    
    // Callback for gesture recognition
    var onGestureRecognized: ((CGPoint, CGVector, CGFloat) -> Void)?
    
    // MARK: - Touch Handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let allTouches = event?.allTouches else { return }
        
        // We want exactly 2 touches
        if allTouches.count == 2 {
            initialTouches = Array(allTouches)
            currentTouches = Array(allTouches)
            state = .began
        } else {
            // If not exactly 2 touches, fail immediately to let other gestures work
            state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard state == .began || state == .changed,
              let allTouches = event?.allTouches,
              allTouches.count == 2 else {
            state = .failed
            return
        }
        
        currentTouches = Array(allTouches)
        
        // Check if the gesture is valid
        if isValidTwoFingerSwipe() {
            state = .changed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (event?.allTouches) != nil else {
            state = .failed
            return
        }
        
        // If we still have exactly 2 touches and the gesture was valid
        if (state == .began || state == .changed) && isValidTwoFingerSwipe() {
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
    
    private func isValidTwoFingerSwipe() -> Bool {
        guard initialTouches.count == 2,
              currentTouches.count == 2,
              let view = view else { return false }
        
        // Get initial and current positions for both fingers
        let finger1Initial = initialTouches[0].location(in: view)
        let finger2Initial = initialTouches[1].location(in: view)
        let finger1Current = currentTouches[0].location(in: view)
        let finger2Current = currentTouches[1].location(in: view)
        
        // Calculate movement vectors for each finger
        let finger1Movement = CGVector(
            dx: finger1Current.x - finger1Initial.x,
            dy: finger1Current.y - finger1Initial.y
        )
        let finger2Movement = CGVector(
            dx: finger2Current.x - finger2Initial.x,
            dy: finger2Current.y - finger2Initial.y
        )
        
        // Calculate distances moved
        let finger1Distance = sqrt(finger1Movement.dx * finger1Movement.dx + finger1Movement.dy * finger1Movement.dy)
        let finger2Distance = sqrt(finger2Movement.dx * finger2Movement.dx + finger2Movement.dy * finger2Movement.dy)
        
        // Check if both fingers moved minimum distance
        guard finger1Distance >= minimumDistance && finger2Distance >= minimumDistance else {
            return false
        }
        
        // Check if fingers are not too far apart initially
        let initialSeparation = sqrt(
            pow(finger1Initial.x - finger2Initial.x, 2) + 
            pow(finger1Initial.y - finger2Initial.y, 2)
        )
        guard initialSeparation <= maximumFingerSeparation else {
            return false
        }
        
        // Check if fingers are moving in roughly the same direction (parallel movement)
        let dotProduct = finger1Movement.dx * finger2Movement.dx + finger1Movement.dy * finger2Movement.dy
        let magnitude1 = sqrt(finger1Movement.dx * finger1Movement.dx + finger1Movement.dy * finger1Movement.dy)
        let magnitude2 = sqrt(finger2Movement.dx * finger2Movement.dx + finger2Movement.dy * finger2Movement.dy)
        
        guard magnitude1 > 0 && magnitude2 > 0 else { return false }
        
        let cosineAngle = dotProduct / (magnitude1 * magnitude2)
        
        // cosineAngle should be close to 1 for parallel movement in same direction
        return cosineAngle >= minimumParallelMovement
    }
    
    private func recognizeGesture() {
        guard initialTouches.count == 2,
              currentTouches.count == 2,
              let view = view else { return }
        
        // Calculate the center point and average movement
        let finger1Initial = initialTouches[0].location(in: view)
        let finger2Initial = initialTouches[1].location(in: view)
        let finger1Current = currentTouches[0].location(in: view)
        let finger2Current = currentTouches[1].location(in: view)
        
        let centerPoint = CGPoint(
            x: (finger1Initial.x + finger2Initial.x) / 2,
            y: (finger1Initial.y + finger2Initial.y) / 2
        )
        
        let averageMovement = CGVector(
            dx: ((finger1Current.x - finger1Initial.x) + (finger2Current.x - finger2Initial.x)) / 2,
            dy: ((finger1Current.y - finger1Initial.y) + (finger2Current.y - finger2Initial.y)) / 2
        )
        
        let distance = sqrt(averageMovement.dx * averageMovement.dx + averageMovement.dy * averageMovement.dy)
        
        // Add haptic feedback for successful gesture
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Call the callback
        onGestureRecognized?(centerPoint, averageMovement, distance)
    }
    
    // MARK: - Reset
    
    override func reset() {
        super.reset()
        initialTouches.removeAll()
        currentTouches.removeAll()
    }
}

/// SwiftUI wrapper for the two-finger gesture
struct TwoFingerSwipeGesture: UIViewRepresentable {
    let onSwipe: (CGPoint, CGVector, CGFloat) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.isUserInteractionEnabled = true
        
        let gestureRecognizer = TwoFingerSwipeGestureRecognizer()
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
