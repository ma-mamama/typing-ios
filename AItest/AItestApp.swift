//
//  AItestApp.swift
//  AItest
//
//  Created by masato on 2025/08/28.
//

import SwiftUI

@main
struct AItestApp: App {
    @State private var showSplash = true
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showSplash = false
                            }
                        }
                } else {
                    ContentView()
                }
            }
        }
    }
}
