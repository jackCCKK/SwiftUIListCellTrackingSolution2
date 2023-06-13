import SwiftUI

public extension View {
    func onFullyVisible(perform action: @escaping () -> Void) -> some View {
        modifier(FullyVisibilityHandler(onFullyVisible: action, onNotFullyVisible: nil))
    }

    func onNotFullyVisible(perform action: @escaping () -> Void) -> some View {
        modifier(FullyVisibilityHandler(onFullyVisible: nil, onNotFullyVisible: action))
    }
}

private struct FullyVisibilityHandler: ViewModifier {
    let onFullyVisible: (() -> Void)?
    let onNotFullyVisible: (() -> Void)?
    @State private var hasBecomeFullyVisible: Bool = false

    func body(content: Content) -> some View {
        content
            .background(GeometryReader { proxy in
                FullyVisiblePreferenceSetter(proxy: proxy, onFullyVisible: onFullyVisible, onNotFullyVisible: onNotFullyVisible, hasBecomeFullyVisible: $hasBecomeFullyVisible)
            })
    }
}

private struct FullyVisiblePreferenceSetter: View {
    let proxy: GeometryProxy
    let onFullyVisible: (() -> Void)?
    let onNotFullyVisible: (() -> Void)?
    @Binding var hasBecomeFullyVisible: Bool

    var body: some View {
        Color.clear.preference(key: VisibleBoundsPreferenceKey.self, value: proxy.frame(in: .global))
            .onPreferenceChange(VisibleBoundsPreferenceKey.self) { newValue in
                if let globalBounds = newValue, let visibleBounds = UIScreen.main.visibleFrame {
                    if visibleBounds.contains(globalBounds), !hasBecomeFullyVisible {
                        hasBecomeFullyVisible = true
                        onFullyVisible?()
                    } else if !visibleBounds.contains(globalBounds), hasBecomeFullyVisible {
                        hasBecomeFullyVisible = false
                        onNotFullyVisible?()
                    }
                }
            }
    }
}

private struct VisibleBoundsPreferenceKey: PreferenceKey {
    typealias Value = CGRect?
    static var defaultValue: Value = nil
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

extension UIScreen {
    var visibleFrame: CGRect? {
        return UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?.windows
            .filter { $0.isKeyWindow }
            .first?.frame
    }
}
