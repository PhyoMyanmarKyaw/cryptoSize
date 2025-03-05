//
//  AppEntry.swift
//  CryptoSize
//
//  Created by Phyo Myanmar Kyaw on 2/25/25.
//

import SwiftUI

@main
struct AppEntry: App {
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacContentView()
                .frame(width: 800, height: 600)
                .fixedSize()
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
