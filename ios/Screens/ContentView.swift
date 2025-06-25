//
//  ContentView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI
import MusicKit

public enum MusicProvider: String{
    case spotify
    case apple
}

struct ConnectButtonWrapper: UIViewRepresentable {
    let connectButton: UIButton
    
    func makeUIView(context: Context) -> UIButton {
        return connectButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
}

struct ContentView: View {
    @State private var showStartScreen: Bool = true
    @AppStorage("firstPickup") private var firstPickup = true
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state

    var body: some View {
        ZStack {
            if firstPickup {
                MusicProviderSelector(
                    firstPickup : $firstPickup,
                    musicProvider: musicProvider)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .zIndex(3)
                    .transition(.opacity)
            }
            if musicProvider == .apple {
                MainTabView()
                PlayerStatusBar(playerState: playerState)
            }
            else {
                MainTabView()
                PlayerStatusBarSpotify()
            }
            
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
