//
//  SearchMusicViewSpotify.swift
//  vibe
//
//  Created by Jayden Chun on 5/29/25.
//

import SwiftUI
import Foundation



struct SearchMusicViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    
    @State private var searchTerm: String = ""
    @State private var isLoading: Bool = false

    
    var body: some View {
        VStack {
            TextField("Search Music", text: $searchTerm)
                .onSubmit(searchMusic)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .multilineTextAlignment(.center)
                

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .padding()
            }

//            if musicProvider == .apple {
//                SongListView(
//                    songs: songs,
//                    currentSongID: player.queue.currentEntry?.item?.id,
//                    isPlaying: playerState.playbackStatus == .playing,
//                    onSelect: handlePlayPressed
//                )
//            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }

    private func searchMusic() {
        guard let URL = URL(string: "https://api.spotify.com/v1/search?q=eminem&type=track&limit=10") else {
                print("Invalid URL")
                return
        }
        let task = URLSession.shared.dataTask(with: URL) {(data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else { print("No data received"); return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        //request limit = 10
        //print("Search failed: \(error)")
    }

    private func handlePlayPressed(song: String) {
        Task {
//            if player.queue.currentEntry?.item?.id == song.id, playerState.playbackStatus == .playing {
//                player.pause()
//            } else {
//                player.queue = [song]
//                try await player.play()
//            }
            
        }
    }
}

#Preview {
    SearchMusicView()
}
