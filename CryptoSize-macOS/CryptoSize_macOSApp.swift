//
//  CryptoSize_macOSApp.swift
//  CryptoSize-macOS
//
//  Created by Phyo Myanmar Kyaw on 3/5/25.
//

import SwiftUI
import AppKit

// Create a custom scene delegate to handle window configuration
class SceneDelegate: NSObject, NSWindowDelegate {
    func windowDidBecomeMain(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        window.styleMask.remove(.resizable)
        window.setContentSize(NSSize(width: 800, height: 600))
        window.center()
    }
    
    func windowWillResize(_ window: NSWindow, to frameSize: NSSize) -> NSSize {
        return NSSize(width: 800, height: 600)
    }
}

@main
struct CryptoSize_macOSApp: App {
    // Use a StateObject to keep the delegate alive for the app's lifetime
    @StateObject private var delegateKeeper = DelegateKeeper()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 800, height: 600)
                .fixedSize()
                .onAppear {
                    DispatchQueue.main.async {
                        // Configure windows after a short delay to ensure they're created
                        for window in NSApplication.shared.windows {
                            window.delegate = delegateKeeper.sceneDelegate
                            window.styleMask.remove(.resizable)
                            window.setContentSize(NSSize(width: 800, height: 600))
                        }
                    }
                }
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
    }
}

// Helper class to keep the delegate alive
class DelegateKeeper: ObservableObject {
    let sceneDelegate = SceneDelegate()
    
    init() {
        // Add notification observer for new windows
        NotificationCenter.default.addObserver(
            forName: NSWindow.didBecomeKeyNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self, let window = notification.object as? NSWindow else { return }
            
            // Set delegate and make window non-resizable
            window.delegate = self.sceneDelegate
            window.styleMask.remove(.resizable)
            window.setContentSize(NSSize(width: 800, height: 600))
            window.center()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
