//
//  SearchMusicView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI
import MusicKit
import ImageIO




struct SearchMusicView: View {
    private let player: ApplicationMusicPlayer = .shared
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    
    @State private var searchTerm: String = ""
    @State private var isLoading: Bool = false
    @State private var songs: MusicItemCollection<Song> = []
    @State private var selectedSong: Song?

    
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

            SongListView(
                songs: songs,
                currentSongID: player.queue.currentEntry?.item?.id,
                isPlaying: playerState.playbackStatus == .playing,
                onSelect: handlePlayPressed
            )
        }
        .padding()
        .onAppear {
            Task {
                if MusicAuthorization.currentStatus != .authorized && musicProvider == .apple{
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

#Preview {
    SearchMusicView()
}
