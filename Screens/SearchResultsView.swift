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
    
    @State private var searchTerm: String = ""
    @State private var songs: MusicItemCollection<Song> = []
    
    @State var selectedSong: Song?
    
    var body: some View {
        VStack {
            TextField("Search Term", text: $searchTerm)
                .onSubmit {
                    searchMusic(for: searchTerm)
                }
            ForEach(songs) { song in
                Button (action: {
                    selectedSong = song
                    handlePlay()
                }) {
                    MusicItemEntry(for: song)
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
    private func handlePlay() -> Void {
        Task {
            if selectedSong != nil {
                player.queue = [selectedSong.unsafelyUnwrapped]
                try await player.play()
            }
        }
    }
}

#Preview {
    SearchResultsView()
}
