import SwiftUI

public let minDragDistance: CGFloat = 80

// Internal detector for the two-finger swipe gesture
private struct TwoFingerSwipeDetector: UIViewRepresentable {
    var direction: UISwipeGestureRecognizer.Direction
    var onSwipe: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let gesture = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleGesture))
        gesture.numberOfTouchesRequired = 2
        gesture.direction = direction
        
        view.addGestureRecognizer(gesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onSwipe: onSwipe)
    }
    
    class Coordinator: NSObject {
        let onSwipe: () -> Void
        
        init(onSwipe: @escaping () -> Void) {
            self.onSwipe = onSwipe
        }
        
        @objc func handleGesture() {
            onSwipe()
        }
    }
}

// Extension for adding the two-finger swipe gesture to any view
extension View {
    /// Adds a two-finger swipe gesture to a view
    /// 
    /// This method adds a UIKit-based swipe gesture recognizer that detects swipes with two fingers
    /// in the specified direction.
    ///
    /// - Parameters:
    ///   - direction: The direction in which to detect swipes (e.g., .up, .down, .left, .right)
    ///   - action: The closure to execute when a swipe is detected
    /// - Returns: A view with the two-finger swipe gesture attached
    public func twoFingerSwipe(direction: UISwipeGestureRecognizer.Direction, perform action: @escaping () -> Void) -> some View {
        self.overlay(
            TwoFingerSwipeDetector(direction: direction, onSwipe: action)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        )
    }
}
