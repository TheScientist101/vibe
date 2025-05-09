//
//  ContentView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var searchTerm: String = ""
    @State private var albums: MusicItemCollection<Album> = []
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            TextField("Search Term", text: $searchTerm)
                .onSubmit {
                    searchMusic(for: searchTerm)
                }
            ForEach(albums) { album in
                MusicItemEntry(for: album)
            }
            Button(action: handlePlay) {
                Text("hello")
            }
        }
        .padding()
    }
    
    @MainActor
    private func apply(_ searchTermResponse: MusicCatalogSearchResponse, for searchTerm: String) {
        if self.searchTerm == searchTerm {
            self.albums = searchTermResponse.albums
        }
    }
    
    private func searchMusic(for searchTerm: String) -> Void {
        Task {
            var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self, Album.self])
            searchRequest.includeTopResults.toggle()
            searchRequest.limit = 10
            
            let searchResponse = try await searchRequest.response()
            
            self.apply(searchResponse, for: searchTerm)
        }
    }
    
    private func handlePlay() -> Void {
//        player.queue.insert(, position: MusicPlayer.Queue.EntryInsertionPosition.afterCurrentEntry)
    }
}

#Preview {
    ContentView()
}
