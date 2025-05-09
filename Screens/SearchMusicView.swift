//
//  SearchMusicView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/8/25.
//

import SwiftUI
import MusicKit

struct SearchMusicView: View {
    private let player: ApplicationMusicPlayer = .shared
    @ObservedObject private var playerState: ApplicationMusicPlayer.State = ApplicationMusicPlayer.shared.state

    @State private var searchTerm: String = ""
    @State private var songs: MusicItemCollection<Song> = []
    
    @State private var selectedSong: Song?
    @State private var showLoadingIndicator: Bool = false
    
    var body: some View {
        VStack {
            TextField("Search Term", text: $searchTerm)
                .onSubmit {
                    searchMusic(for: searchTerm)
                }
            ScrollView {
                if showLoadingIndicator {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .controlSize(.large)
                }
                    
                ForEach(songs) { song in
                    Button (action: {
                        selectedSong = song
                        handlePlayPressed()
                    }) {
                        MusicItemEntry(for: song, isPlaying: player.queue.currentEntry?.item?.id == song.id && playerState.playbackStatus == .playing)
                    }
                }
            }
        }
        .padding()
        .preferredColorScheme(.dark)
    }
    
    @MainActor
    private func apply(_ searchTermResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.songs = searchTermResponse.songs
        }
    }
    
    private func searchMusic(for searchTerm: String) -> Void {
        showLoadingIndicator = true
        
        Task {
            var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self, Album.self, Playlist.self])
            searchRequest.includeTopResults.toggle()
            searchRequest.limit = 10
            
            let searchResponse = try await searchRequest.response()
            
            player.pause()
            showLoadingIndicator = false
            
            self.apply(searchResponse, for: searchTerm)
        }
    }
    
    @MainActor
    private func handlePlayPressed() -> Void {
        Task {
            if player.queue.currentEntry?.item?.id == selectedSong.unsafelyUnwrapped.id && playerState.playbackStatus == .playing {
                player.pause()
            } else {
                player.queue = [selectedSong.unsafelyUnwrapped]
                try await player.play()
            }
        }
    }
}

#Preview {
    SearchMusicView()
}
