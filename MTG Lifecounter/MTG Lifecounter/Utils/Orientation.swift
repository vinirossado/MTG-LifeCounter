import SwiftUI
import UIKit

enum DeviceOrientation {
    case portrait
    case landscape
}

@Observable
class DeviceOrientationManager {
    var orientation: DeviceOrientation = .portrait
    var size: CGSize = .zero
    var isLandscape: Bool = false
    var width: CGFloat = 0
    var height: CGFloat = 0
    let isPad: Bool = UIDevice.current.userInterfaceIdiom == .pad
    
    // Singleton
    static let shared = DeviceOrientationManager()
    
    private init() {}
    
    func updateOrientation(size: CGSize) {
       //Guard to check if the screen has been changed
        guard self.size != size else { return }
        
        self.size = size
        self.width = size.width
        self.height = size.height
        let newIsLandscape = size.width > size.height
        
        if self.isLandscape != newIsLandscape {
            self.isLandscape = newIsLandscape
            self.orientation = newIsLandscape ? .landscape : .portrait
        }
    }
    
    // Retorna valores específicos para diferentes orientações
    func value<T>(portrait: T, landscape: T) -> T {
        isLandscape ? landscape : portrait
    }
    
    // Returns padding based on orientation
    var adaptivePadding: EdgeInsets {
        value(
            portrait: EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20),
            landscape: EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40)
        )
    }
    
    // Returns spacing based on orientation
    var adaptiveSpacing: CGFloat {
        value(portrait: 20, landscape: 40)
    }
}

struct DeviceOrientationModifier: ViewModifier {
    @State private var manager: DeviceOrientationManager
    
    init(manager: DeviceOrientationManager = .shared) {
        _manager = State(initialValue: manager)
    }
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .onAppear {
                    UIApplication.shared.isIdleTimerDisabled = true
                    manager.updateOrientation(size: geometry.size)
                }
                .onChange(of: geometry.size) { oldSize, newSize in
                    manager.updateOrientation(size: newSize)
                }
                .onDisappear() {
                    UIApplication.shared.isIdleTimerDisabled = false
                }
        }
    }
}

extension View {
    func trackDeviceOrientation() -> some View {
        modifier(DeviceOrientationModifier())
    }
}

// Two-finger gesture recognizer
class TwoFingerSwipeGestureRecognizer: UIGestureRecognizer {
    var direction: UISwipeGestureRecognizer.Direction
    var onSwipe: () -> Void
    
    init(direction: UISwipeGestureRecognizer.Direction, onSwipe: @escaping () -> Void) {
        self.direction = direction
        self.onSwipe = onSwipe
        super.init(target: nil, action: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let allTouches = event.allTouches, allTouches.count == 2 {
            self.state = .began
        } else {
            self.state = .failed
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let allTouches = event.allTouches, allTouches.count == 2, self.state == .began {
            let touchesArray = Array(allTouches)
            
            if touchesArray.count == 2 {
                let firstTouch = touchesArray[0]
                let secondTouch = touchesArray[1]
                
                let firstMovement = firstTouch.location(in: self.view).y - firstTouch.previousLocation(in: self.view).y
                let secondMovement = secondTouch.location(in: self.view).y - secondTouch.previousLocation(in: self.view).y
                
                if direction == .up && firstMovement < -5 && secondMovement < -5 {
                    self.state = .recognized
                    onSwipe()
                } else if direction == .down && firstMovement > 5 && secondMovement > 5 {
                    self.state = .recognized
                    onSwipe()
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if self.state == .began {
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.state = .failed
    }
}

// SwiftUI wrapper for the two-finger gesture
struct TwoFingerSwipeGesture: UIViewRepresentable {
    var direction: UISwipeGestureRecognizer.Direction
    var onSwipe: () -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let gesture = TwoFingerSwipeGestureRecognizer(direction: direction, onSwipe: onSwipe)
        view.addGestureRecognizer(gesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
