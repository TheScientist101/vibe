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
    @State private var clicked: Bool = false
//    let viewController = ViewController()
//    var remoteDelegate: SPTAppRemoteDelegate
//    var appRemotes: SPTAppRemote
//    @State var connected = false;
    

    var body: some View {
        ZStack {
            if firstPickup {
                MusicProviderSelector(
                    firstPickup : $firstPickup,
                    musicProvider: musicProvider)
//                    sessionManager: ViewController().sessionManager)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .zIndex(1)
                    .transition(.opacity)
            }
            if !firstPickup && musicProvider == .spotify && !clicked{
                Button(action: {
//                    connected = true;
//                    viewController.didTapConnect(UIButton());
//                    remoteDelegate.appRemoteDidEstablishConnection(appRemotes)
                    firstPickup = false;
                    clicked = true
                }){
                    Text("Connect to Spotify")
                }
                .zIndex(2)
                .frame(width: 120, height: 50)
                .foregroundStyle(.white)
                .padding(.horizontal, 30)
                .background(Color.green)
                .bold()
                .cornerRadius(20)
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

//#Preview {
//    ContentView(musicProvider: .apple, remoteDelegate: SPTAppRemoteDelegate, connected: false)
//}
