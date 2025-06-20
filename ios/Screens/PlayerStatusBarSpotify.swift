//
//  PlayerStatusBarSpotify.swift
//  vibe
//
//  Created by Jayden Chun on 6/16/25.
//

import SwiftUI

struct PlayerStatusBarSpotify: View {
//    let songs: [SpotifyTrack]
//    @AppStorage("currentSong") var currentSong: SpotifyTrack
    @ObservedObject var manager = SpotifyManager.shared

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: manager.currentTrack?.album.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        
                    }
                    .frame(width: 50, height: 50, alignment: .leading)
                    .cornerRadius(8)
                    .frame(alignment: .leading)
                    VStack(alignment: .leading, spacing: 15){
                        Text(manager.currentTrack?.name ?? "")
                            .frame(maxHeight: 1, alignment: .leading)
                            .foregroundColor(.white)
                        Text(manager.currentTrack?.artistName ?? "")
                            .frame(maxHeight: 1, alignment: .leading)
                            .foregroundColor(.white)
                            .font(.system(size:10))
                    }
                    Spacer()
                    if let _ = manager.currentTrack?.name
                    {
                        Button(action:{
                            manager.currentTrackPlaying = !manager.currentTrackPlaying
                            print("is current track playing? -> " + String(manager.currentTrackPlaying))
                            !manager.currentTrackPlaying ? manager.handlePausePressed(track: manager.currentTrack!) : manager.handleResumePressed(track: manager.currentTrack!)
                        }) {
                            Image(systemName: manager.currentTrackPlaying ? "pause.fill" : "play.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                .background(Color.black.opacity(1))
                .frame(idealWidth: .infinity, maxWidth: .infinity, alignment: .center)
                .offset(y: -0.08 * geometry.size.height)//hardcoding the ui here
                //            .padding(.bottom, 60)
            }
//            .safeAreaInset(edge: .bottom) {
//                Color.clear.frame(height: geometry.size.height * 0.5)
//            }
        }
    }

//    private var currentTrackTitle: String {
//        if playerState.playbackStatus == .playing {
//            return ApplicationMusicPlayer.shared.queue.currentEntry?.title ?? "No music playing"
//        }
//        return "No music playing"
//    }
}
