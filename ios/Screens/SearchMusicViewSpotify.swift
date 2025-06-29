//  SearchMusicViewSpotify.swift
//  vibe
//  Created by Jayden Chun on 5/29/25.

import SwiftUI
import Foundation

struct SearchMusicViewSpotify: View {
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @AppStorage("auth0IdToken") private var idToken: String = "" // set this after login
//    @ObservableObject("currentSong") var currentSong: SpotifyTrack
    @State private var spotifyTracks: [SpotifyTrack] = []
    @State private var searchTerm: String = ""
    @State private var isLoading: Bool = false
    @State private var noActiveDeviceAvailable: Bool = false
    @State private var connectedToSpotify: Bool = false
    @State private var alertOn: Bool = false
    @ObservedObject var manager = SpotifyManager.shared

    var body: some View {
        VStack {
            TextField("Search Music", text: $searchTerm)
                .onSubmit(searchMusic)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)
                .multilineTextAlignment(.center)
                .alert(isPresented: $alertOn) {
                    Alert(
                        title: Text("Not Connected to Spotify"),
                        message: Text("Connect to Spotify First!"),
                        primaryButton: .default(
                            Text("Connect to Spotify")
                                .foregroundStyle(.green),
                            action: manager.signIn
                        ),
                        secondaryButton: .destructive(
                            Text("Cancel"),
                            action: {}
                        )
                    )
                }
            

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
        alertOn = !connectedToSpotify && manager.spotifyRefreshToken.isEmpty
        if(alertOn) {
            return;
        }
        guard !searchTerm.isEmpty else { return }
        guard let encodedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.spotify.com/v1/search?q=\(encodedSearchTerm)&type=track&limit=10") else {
            print("Invalid Search Term URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(manager.spotifyAccessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
                    self.spotifyTracks = searchResponse.tracks.items
                    print("accessToken: " + manager.spotifyAccessToken)
                    print("refreshToken: " + manager.spotifyRefreshToken)
//                    print("refreshTokenExpiration" + )
                } catch {
                    print("Error parsing Spotify response: \(error)")
                }
            }
        }
        manager.connectedToSpotify = true
        task.resume()
        
    }

}


//#Preview {
//    SearchMusicViewSpotify()
//}
