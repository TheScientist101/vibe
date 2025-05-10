//
//  ContentView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var showStartScreen: Bool = true
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state

    var body: some View {
        ZStack {
            MainTabView()
            PlayerStatusBar(playerState: playerState)
        }
        .fullScreenCover(isPresented: $showStartScreen) {
            StartView(onStart: startGroove)
        }
        .preferredColorScheme(.dark)
    }

    private func startGroove() {
        showStartScreen = false
    }
}

#Preview {
    ContentView()
}
