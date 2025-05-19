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
    @AppStorage("firstPickup") private var firstPickup = true
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    

    var body: some View {
        ZStack {
            if firstPickup {
                MusicProviderSelector(firstPickup : $firstPickup)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .zIndex(1)
                
                    
            }
            MainTabView()
            PlayerStatusBar(playerState: playerState)
        }
        .fullScreenCover(isPresented: $showStartScreen) {
            StartView(onStart: startGroove)
        }
    }

    private func startGroove() {
        showStartScreen = false
        firstPickup = true
    }
}

#Preview {
    ContentView()
}
