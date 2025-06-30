//
//  MainTabViewSwift.swift
//  vibe
//
//  Created by Jayden Chun on 6/29/25.
//

import SwiftUI

struct MainTabViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @Binding var selectedTab: Int
    var body: some View {
        GeometryReader{ geometry in
            TabView(selection: $selectedTab) {
                SearchMusicViewSpotify()
                    .tabItem {
                        Label("Find Music", systemImage: "music.note")
                    }
                    .tag(0)
                
                Settings()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(1)
            }
            .accentColor(.white)
            
        }
    }
}
//#Preview {
//    MainTabViewSpotify(selectedTab:)
//}
