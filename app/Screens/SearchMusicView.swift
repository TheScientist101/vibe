//
//  SearchMusicView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI
import MusicKit

struct SearchMusicView: View {
    private let player: ApplicationMusicPlayer = .shared
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    
    @State private var searchTerm: String = ""
    @State private var songs: MusicItemCollection<Song> = []
    @State private var selectedSong: Song?
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack {
            TextField("Search Term", text: $searchTerm)
                .onSubmit(searchMusic)

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .padding()
            }

            SongListView(
                songs: songs,
                currentSong: player.queue.currentEntry?.item as? Song,
                isPlaying: playerState.playbackStatus == .playing,
                onSelect: handlePlayPressed
            )
        }
        .padding()
        .onAppear {
            Task {
                if MusicAuthorization.currentStatus != .authorized {
                    print(await MusicAuthorization.request())
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private func searchMusic() {
        guard !searchTerm.isEmpty else { return }
        isLoading = true

        Task {
            do {
                var request = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
                request.limit = 10
                let response = try await request.response()

                if self.searchTerm == searchTerm {
                    songs = response.songs
                }
            } catch {
                print("Search failed: \(error)")
            }

            isLoading = false
        }
    }

    private func handlePlayPressed(song: Song) {
        Task {
            if player.queue.currentEntry?.item?.id == song.id, playerState.playbackStatus == .playing {
                player.pause()
            } else {
                player.queue = [song]
                try await player.play()
            }
        }
    }
}
