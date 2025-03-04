import SwiftUI

struct CryptoSizeMacApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
        
        #if os(macOS)
        Settings {
            SettingsView()
        }
        #endif
    }
}
