//
//  SearchResultsView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/8/25.
//

import SwiftUI
import MusicKit

struct SearchResultsView: View {
    private let player: ApplicationMusicPlayer = .shared
    @ObservedObject private var playerState: ApplicationMusicPlayer.State = ApplicationMusicPlayer.shared.state
    
    @State private var searchTerm: String = ""
    @State private var songs: MusicItemCollection<Song> = []
    
    @State var selectedSong: Song?
    
    var body: some View {
        VStack {
            TextField("Search Term", text: $searchTerm)
                .onSubmit {
                    searchMusic(for: searchTerm)
                }
            ScrollView {
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
    }
    
    @MainActor
    private func apply(_ searchTermResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.songs = searchTermResponse.songs
        }
    }
    
    private func searchMusic(for searchTerm: String) -> Void {
        Task {
            var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self, Album.self, Playlist.self])
            searchRequest.includeTopResults.toggle()
            searchRequest.limit = 10
            
            let searchResponse = try await searchRequest.response()
            
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
    SearchResultsView()
}
