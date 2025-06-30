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

struct ContentView: View {
    @State private var showStartScreen: Bool = true
    @State private var popupShown: Bool = false
    @State private var selectedTab: Int = 0
    @AppStorage("firstPickup") private var firstPickup = true
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    @ObservedObject var manager = SpotifyManager.shared

    var body: some View {
        GeometryReader{ geometry in
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
                    MainTabViewSpotify()
                    PlayerStatusBarSpotifyPrecise()
                    if !manager.connectedToSpotify {
                        Button(action:{
                            popupShown.toggle()
                            manager.signIn()
                        })
                        {
                            Circle()
                                .fill(.red)
                                .frame(width: 30, height: 30)
                        }
                        .position(
                            x: geometry.size.width*0.93,
                            y: 0)
                        .zIndex(1)
                    }
                    else {
                        Circle()
                            .fill(.green)
                            .frame(width: 30, height: 30)
                            .position(
                                x: geometry.size.width*0.93,
                                y: 0)
                            .zIndex(1)
                    }
                }
                
            }
            .fullScreenCover(isPresented: $showStartScreen) {
                StartView(onStart: startGroove)
            }
        }
    }
        

    private func startGroove() {
        showStartScreen = false
        firstPickup = true
    }
}
