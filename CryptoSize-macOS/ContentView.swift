//
//  ContentView.swift
//  CryptoSize-macOS
//
//  Created by Phyo Myanmar Kyaw on 3/5/25.
//

import SwiftUI
import Combine

struct ContentView: View {
    var body: some View {
        MacContentView()
            .frame(width: 800, height: 600)
            .fixedSize()
    }
}

#Preview {
    ContentView()
}
