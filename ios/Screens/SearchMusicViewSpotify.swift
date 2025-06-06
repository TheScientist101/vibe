//  SearchMusicViewSpotify.swift
//  vibe
//  Created by Jayden Chun on 5/29/25.

import SwiftUI
import Foundation

struct SearchMusicViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @AppStorage("auth0IdToken") private var idToken: String = "" // set this after login
    @AppStorage("spotifyAccessToken") private var spotifyAccessToken: String = ""
    @State private var spotifyTracks: [SpotifyTrack] = []
    
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
//                .onAppear {
//                    
//                }

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
                    .padding()
            }
            
            SongListViewSpotify(
                songs: spotifyTracks,
                isPlaying: false,
                onSelect: handlePlayPressed(track:)
            )
        }
        .padding()
        .preferredColorScheme(.dark)
    }
    private func searchMusic() {
        guard !searchTerm.isEmpty else { return }
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedSearchTerm)&type=track&limit=10") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(spotifyAccessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
                    self.spotifyTracks = searchResponse.tracks.items
                } catch {
                    print("Error parsing Spotify response: \(error)")
                }
            }
        }
        task.resume()
        
    }
    
    private func handlePlayPressed(track: SpotifyTrack) {
        Task {
            // placeholder for Spotify playback integration
        }
    }
}

#Preview {
    SearchMusicViewSpotify()
}
