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
        guard let accessToken = manager.spotifyToken?.access_token else {
            print("no accessToken in search music function")
            return
        }
        guard let refreshToken = manager.spotifyToken?.refresh_token else {
            print("no refreshToken in search music function")
            return
        }
        guard let expDate = manager.spotifyToken?.expires_in else {
            print("no expiration date available in search music function")
            return
        }
        alertOn = !connectedToSpotify && refreshToken.isEmpty
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
//        request.setValue("Bearer \(manager.spotifyAccessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let searchResponse = try JSONDecoder().decode(SpotifySearchResponse.self, from: data)
                    self.spotifyTracks = searchResponse.tracks.items
//                    print("accessToken: " + manager.spotifyToken?.access_token ?? "no accessToken")
//                    print("refreshToken: " + manager.spotifyToken?.refresh_token ?? "no refreshToken")
                    print("accessToken: " + accessToken)
                    print("refreshToken: " + refreshToken)
                    print("expiration time" + String(expDate))
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
