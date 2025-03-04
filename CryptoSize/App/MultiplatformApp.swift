import SwiftUI

struct MultiplatformApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacContentView()
                .frame(minWidth: 800, minHeight: 600)
            #else
            ContentView()
            #endif
        }
        #if os(macOS)
        .windowStyle(DefaultWindowStyle())
        .windowToolbarStyle(UnifiedWindowToolbarStyle())

        #endif
    }
}

#if os(macOS)
struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .padding()
            
            Form {
                Toggle("Dark Mode", isOn: .constant(true))
                    .padding()
                
                Divider()
                
                Text("Version 1.0.0")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .frame(width: 400, height: 300)
    }
}
#endif
