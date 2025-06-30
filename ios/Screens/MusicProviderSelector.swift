//
//  MusicProviderSelector.swift
//  vibe
//
//  Created by Jayden Chun on 5/10/25.
//
import Foundation
import SwiftUI
import UIKit

struct MusicProviderSelector: View {
    @Binding var firstPickup: Bool
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @ObservedObject var manager = SpotifyManager.shared
    
    var body: some View {
        VStack {
            Text("Select Your Music Provider:")
            
            Button(action: {
                musicProvider = .spotify
                firstPickup = false
                print(musicProvider)
                manager.signIn()
//                print(manager.connectedToSpotify)
            }) {
                Text("Spotify")
            }
            .padding()
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
            .background(.green)
            .cornerRadius(10)
            .bold()
            
            Button(action: {
                musicProvider = .apple
                firstPickup = false
                print(musicProvider)
            }) {
                Text("Apple Music")
            }
            .padding()
            .foregroundStyle(.white)
            .padding(.horizontal, 10)
            .background(.pink)
            .cornerRadius(10)
            .bold()
        }
    }
}
