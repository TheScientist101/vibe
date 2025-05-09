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
    @ObservedObject private var playerState: ApplicationMusicPlayer.State = ApplicationMusicPlayer.shared.state
    
    var body: some View {
        ZStack {
            TabView {
                SearchMusicView()
                    .tabItem {
                        Image(systemName: "music.note")
                        Text("Find Music")
                    }
                
                Text("Settings")
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            
            VStack {
                Spacer()
                Text((playerState.playbackStatus == .playing ? ApplicationMusicPlayer.shared.queue.currentEntry?.title : "No music playing") ?? "No music playing")
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.red)
                    .padding(60)
            }
        }.fullScreenCover(isPresented: $showStartScreen) {
                VStack(spacing: 40) {
                    Text("Vibe")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .shadow(radius: 10)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    Button(action: startGroove) {
                        Text("Start a Groove")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.black)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                }
            }
        .preferredColorScheme(ColorScheme.dark)
    }
    
    private func startGroove() -> Void {
        showStartScreen.toggle()
    }
}

#Preview {
    ContentView()
}
