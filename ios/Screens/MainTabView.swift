//
//  MainTabView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            SearchMusicView()
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

//#Preview {
//    MainTabView()
//}
