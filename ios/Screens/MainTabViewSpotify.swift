//
//  MainTabViewSwift.swift
//  vibe
//
//  Created by Jayden Chun on 6/29/25.
//

import SwiftUI

struct MainTabViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    var body: some View {
        GeometryReader{ geometry in
            TabView{
                SearchMusicViewSpotify()
                    .tabItem {
                        Label("Find Music", systemImage: "music.note")
                    }
                Connect()
                    .tabItem {
                        Label("Connect", systemImage: "person.crop.circle")
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
//#Preview {
//    MainTabViewSpotify(selectedTab:)
//}
