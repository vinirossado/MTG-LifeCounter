import SwiftUI

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

// Exemplo de uso com a sintaxe moderna
//struct ExampleView: View {
//    @State private var manager = DeviceOrientationManager.shared
//    
//    var body: some View {
//        VStack {
//            if manager.isLandscape {
//                HStack {
//                    contentView
//                }
//            } else {
//                VStack {
//                    contentView
//                }
//            }
//        }
//        .padding(manager.adaptivePadding)
//        .trackDeviceOrientation()
//    }
//    
//    @ViewBuilder
//    private var contentView: some View {
//        // Seu conteúdo aqui
//        Text("Example Content")
//            .frame(maxWidth: manager.value(portrait: 600, landscape: 800))
//    }
//}
