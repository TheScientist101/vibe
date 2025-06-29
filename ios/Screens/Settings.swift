//
//  Settings.swift
//  vibe
//
//  Created by Jayden Chun on 5/12/25.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var darkMode: Bool = false
}

@MainActor
struct Settings: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var appleMusic = true
    @State private var connectedToSpotify = false
    @AppStorage("musicProvider") var musicProvider: MusicProvider = true ? .apple : .spotify
    @ObservedObject var manager = SpotifyManager.shared
    var body: some View {
        if(musicProvider == .apple)
        {
            Toggle("Apple Music", isOn: $appleMusic)
                .onChange(of: appleMusic) {
                    musicProvider = appleMusic ? .apple : .spotify
//                    print("current music provider is " + String(musicProvider == .apple ? "Apple" : "Spotify"))
                }
                .tint(Color.pink)
        }
        else {
            VStack {
                Toggle("Spotify", isOn: $appleMusic)
                    .onChange(of: appleMusic) {
                        musicProvider = appleMusic ? .spotify : .apple
//                        print("current music provider is " + String(musicProvider == .apple ? "Apple" : "Spotify"))
                    }
                    .tint(Color.green)
                Button(action: manager.connectedToSpotify ? {print("Already Connected to Spotify")} : manager.signIn){
                    Text(manager.connectedToSpotify ? "Connected to Spotify" : "Not Connected to Spotify")
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(
                    Capsule()
                        .fill(manager.connectedToSpotify ? Color.green : Color.red)
                )
                .foregroundStyle(manager.connectedToSpotify ? Color.white : Color.black)
                
            }
        }
    }
}

#Preview {
    Settings()
}
