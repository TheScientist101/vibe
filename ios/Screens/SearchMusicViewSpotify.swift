//  SearchMusicViewSpotify.swift
//  vibe
//  Created by Jayden Chun on 5/29/25.

import SwiftUI
import Foundation

struct SearchMusicViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @AppStorage("auth0IdToken") private var idToken: String = "" // set this after login
    @AppStorage("spotifyAccessToken") private var spotifyAccessToken: String = ""
//    @ObservableObject("currentSong") var currentSong: SpotifyTrack
    @State private var spotifyTracks: [SpotifyTrack] = []
    @State private var searchTerm: String = ""
    @State private var isLoading: Bool = false
    @State private var noActiveDeviceAvailable: Bool = false
    @ObservedObject var manager = SpotifyManager.shared

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
            
            SongListViewSpotify(
                songs: spotifyTracks,
                isPlaying: false,
                onSelect: manager.handlePlayPressed(track:)
            )
        }
        .padding()
        .preferredColorScheme(.dark)
        .alert("Open Spotify", isPresented: $noActiveDeviceAvailable) {
            Button("Open App") {
                if let url = URL(string: "spotify://") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Open Spotify and quickly play and pause a song to get started!")
        }

    }
    private func searchMusic() {
        
        guard !searchTerm.isEmpty else { return }
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedSearchTerm)&type=track&limit=10") else {
            print("Invalid Search Term URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(spotifyAccessToken)", forHTTPHeaderField: "Authorization")
        
//        guard let refreshUrl = URL(string: "https://accounts.spotify.com/api/token") else {
//            print("Invalid refresh URL")
//            return
//        }
//        var refreshTokenRequest = URLRequest(url: refreshUrl)
//        refreshTokenRequest.httpMethod = "POST"
//        refreshTokenRequest.setValue("Basic ", forHTTPHeaderField: "Basic")
        //^Was for refresh token request

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
    
    

}

//#Preview {
//    SearchMusicViewSpotify()
//}
