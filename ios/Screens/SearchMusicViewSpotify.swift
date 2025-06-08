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
    @State private var noActiveDeviceAvailable: Bool = false

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
//        .alert(isPresented: $noActiveDeviceAvailable){
//            Alert(
//                title: Text("Open Spotify"),
//                message: Text("Please open the Spotify app so we can play music."),
//                primaryButton: .default(Text("Open App"), action: {
//                    UIApplication.shared.open(URL(string: "spotify://")!)
//                }),
//                secondaryButton: .cancel()
//            )
//        }
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
    
    private func handlePlayPressed(track: SpotifyTrack) {
        print("before search: " + String(noActiveDeviceAvailable))
        checkSpotifyDeviceStatus(accessToken: spotifyAccessToken) { isActive in
            if isActive {
                noActiveDeviceAvailable = false
                Task {
                    let payload: [String: Any] = [
                        "uris": [track.uri],
                        "position_ms": 0
                    ]
                    let data = try! JSONSerialization.data(withJSONObject: payload, options: [])
                    let url = URL(string: "https://api.spotify.com/v1/me/player/play")!
                    let headers = [
                        "Authorization": "Bearer \(spotifyAccessToken)",
                        "Content-Type": "application/json"
                    ]

                    var request = URLRequest(url: url)
                    request.httpMethod = "PUT"
                    request.allHTTPHeaderFields = headers
                    request.httpBody = data as Data

                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print(error)
                        } else if let data = data {
                            let str = String(data: data, encoding: .utf8)
                            print(str ?? "")
                        }
                    }

                    task.resume()
                }
            } else {
                noActiveDeviceAvailable = true
                return
            }
        }
    }
    
    func checkSpotifyDeviceStatus(accessToken: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://api.spotify.com/v1/me/player/devices") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(spotifyAccessToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let devices = json["devices"] as? [[String: Any]] else {
                completion(false)
                return
            }

            let hasActiveDevice = devices.contains { device in
                return device["is_active"] as? Bool == true
            }

            completion(hasActiveDevice)
        }.resume()
    }

}

//#Preview {
//    SearchMusicViewSpotify()
//}
