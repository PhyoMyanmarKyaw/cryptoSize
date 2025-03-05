//
//  CryptoSize_macOSApp.swift
//  CryptoSize-macOS
//
//  Created by Phyo Myanmar Kyaw on 3/5/25.
//

import SwiftUI
import AppKit

// MARK: - App Entry Point

@main
struct CryptoSize_macOSApp: App {
    @StateObject private var windowManager = WindowManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: Constants.windowWidth, height: Constants.windowHeight)
                .fixedSize()
                .onAppear {
                    DispatchQueue.main.async {
                        windowManager.configureAllWindows()
                    }
                }
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
    }
}

// MARK: - Window Management

/// Manages window configuration for the macOS app
final class WindowManager: ObservableObject {
    private let windowDelegate = MacWindowDelegate()
    private let notificationCenter = NotificationCenter.default
    
    init() {
        setupWindowNotifications()
    }
    
    deinit {
        notificationCenter.removeObserver(self)
    }
    
    /// Configures all currently open windows
    func configureAllWindows() {
        NSApplication.shared.windows.forEach(configureWindow)
    }
    
    /// Configures a single window with fixed size and non-resizable properties
    private func configureWindow(_ window: NSWindow) {
        window.delegate = windowDelegate
        window.styleMask.remove(.resizable)
        window.setContentSize(NSSize(width: Constants.windowWidth, height: Constants.windowHeight))
        window.center()
    }
    
    /// Sets up notification observers for window events
    private func setupWindowNotifications() {
        notificationCenter.addObserver(
            forName: NSWindow.didBecomeKeyNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self,
                  let window = notification.object as? NSWindow,
                  window.delegate == nil else { return }
            
            self.configureWindow(window)
        }
    }
}

// MARK: - Window Delegate

/// Delegate that handles window-specific behaviors
final class MacWindowDelegate: NSObject, NSWindowDelegate {
    func windowDidBecomeMain(_ notification: Notification) {
        guard let window = notification.object as? NSWindow else { return }
        configureWindow(window)
    }
    
    func windowWillResize(_ window: NSWindow, to frameSize: NSSize) -> NSSize {
        return NSSize(width: Constants.windowWidth, height: Constants.windowHeight)
    }
    
    private func configureWindow(_ window: NSWindow) {
        window.styleMask.remove(.resizable)
        window.setContentSize(NSSize(width: Constants.windowWidth, height: Constants.windowHeight))
        window.center()
    }
}

// MARK: - Constants

/// App-wide constants
private enum Constants {
    static let windowWidth: CGFloat = 800
    static let windowHeight: CGFloat = 600
}
