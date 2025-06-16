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
        VStack {
            Spacer()
            HStack {
                AsyncImage(url: URL(string: manager.currentTrack?.album.imageUrl ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                    .frame(width: 15, height: 15)
                    .cornerRadius(8)
                    .padding([.vertical, .trailing], 8)
                
//                Text("No music playing???")
////                    .frame(maxWidth: .infinity, maxHeight: 1)
//                    .frame(maxHeight: 1)
//                    .foregroundColor(.red)
//                    .padding(60)
            }
        }
    }

//    private var currentTrackTitle: String {
//        if playerState.playbackStatus == .playing {
//            return ApplicationMusicPlayer.shared.queue.currentEntry?.title ?? "No music playing"
//        }
//        return "No music playing"
//    }
}
