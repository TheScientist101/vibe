//
//  MainTabView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI

struct MainTabView: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    var body: some View {
        GeometryReader{ geometry in
            TabView {
                if musicProvider == .apple {
                    SearchMusicView()
                        .tabItem {
                            Label("Find Music", systemImage: "music.note")
                        }
                }
                else if musicProvider == .spotify{
                    SearchMusicViewSpotify()
                        .tabItem {
                            Label("Find Music", systemImage: "music.note")
                        }
                }
                
                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
            .accentColor(.white)
        }
    }
}

#Preview {
    MainTabView()
}
