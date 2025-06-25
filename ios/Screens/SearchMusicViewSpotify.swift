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
                            action: signIn
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
        if(!manager.spotifyAccessToken.isEmpty) {connectedToSpotify = true}
        alertOn = !connectedToSpotify && manager.spotifyAccessToken == ""
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
    
    
//    private func signIn(_ sender: Any) {
    private func signIn() {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let spotifyClientId = Bundle.main.object(forInfoDictionaryKey: "SpotifyClientId") as! String
        let authorizeURL = "https://accounts.spotify.com/authorize"
        let tokenURL = "https://accounts.spotify.com/api/token"
        let redirectUri = "\(bundleIdentifier)://callback"
        let parameters = OAuth2PKCEParameters(
            authorizeUrl: authorizeURL,
            tokenUrl: tokenURL,
            clientId: spotifyClientId,
            redirectUri: redirectUri,
            callbackURLScheme: bundleIdentifier
        )
        
        let authenticator = OAuth2PKCEAuthenticator()
        authenticator.authenticate(parameters: parameters) { result in
            switch result {
            case .success(let accessTokenResponse):
                self.manager.spotifyAccessToken = accessTokenResponse.access_token
                connectedToSpotify = true
            case .failure(let error):
                print("Spotify Auth Error: \(error)")
            }
        }
        Task {
            await self.getRefreshToken()
        }
    }
    
    private func getRefreshToken() async {
        let refreshToken = manager.spotifyRefreshToken
        guard !refreshToken.isEmpty else{
            print("No refresh token available")
            return
        }
        let spotifyClientId = Bundle.main.object(forInfoDictionaryKey: "SpotifyClientId") as! String
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant-type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken),
            URLQueryItem(name: "client_id", value: spotifyClientId)
        ]
        request.httpBody = components.query?.data(using: .utf8)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(TokenResponse.self, from: data)
            
            manager.spotifyAccessToken = response.access_token
            
            if let newRefreshToken = response.refresh_token {
                manager.spotifyRefreshToken = newRefreshToken
            }
            
            print("successfully refreshed access token")
        } catch {
            print("Error refreshing token: \(error)")
        }
    }

}

struct TokenResponse: Codable {
    let access_token: String
    let token_type: String
    let expires_in: Int
    let refresh_token: String?
    let scope: String?
}

//#Preview {
//    SearchMusicViewSpotify()
//}
