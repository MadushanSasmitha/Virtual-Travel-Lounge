import SwiftUI

extension View {
    /// Simple tvOS-like focus scale effect. Use `.scaleEffectOnFocus()` on focusable views.
    func scaleEffectOnFocus(scale: CGFloat = 1.08) -> some View {
        modifier(_ScaleOnFocus(scale: scale))
    }
}

private struct _ScaleOnFocus: ViewModifier {
    @Environment(\.isFocused) private var isFocused: Bool
    let scale: CGFloat

    func body(content: Content) -> some View {
        content
            .scaleEffect(isFocused ? scale : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
            .shadow(color: Color.black.opacity(isFocused ? 0.4 : 0.15), radius: isFocused ? 12 : 6)
    }
}
