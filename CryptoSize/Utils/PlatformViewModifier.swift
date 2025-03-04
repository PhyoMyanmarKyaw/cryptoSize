import SwiftUI

struct PlatformViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        content
            .frame(minWidth: 800, minHeight: 600)
        #else
        content
        #endif
    }
}

extension View {
    func adaptForPlatform() -> some View {
        self.modifier(PlatformViewModifier())
    }
}

#if os(macOS)
typealias PlatformImage = NSImage
#else
typealias PlatformImage = UIImage
#endif
