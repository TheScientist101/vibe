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

            Settings()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    MainTabView()
}
