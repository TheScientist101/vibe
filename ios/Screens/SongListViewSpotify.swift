//
//  SongListViewSpotify.swift
//  vibe
//
//  Created by Jayden Chun on 6/5/25.
//

import SwiftUI
import MusicKit

struct SongListViewSpotify: View {
    let songs: [SpotifyTrack]
//    let currentSongID: String?
    let isPlaying: Bool
    let onSelect: (SpotifyTrack) -> Void

    var body: some View {
        ScrollView {
            ForEach(songs) { SpotifyTrack in
                Button(action: {
                    onSelect(SpotifyTrack)
                }) {
                    HStack(){
                        AsyncImage(url: URL(string: SpotifyTrack.album.imageUrl ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                            .frame(width: 64, height: 64)
                            .cornerRadius(8)
                            .padding([.vertical, .trailing], 8)
                        VStack{
                            Text(SpotifyTrack.name)
                                .font(.headline)
                                .foregroundColor(Color.white)
                                .bold(true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(SpotifyTrack.artistName)
                                .font(.subheadline)
                                .foregroundColor(Color.gray)
                                .bold(true)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        
    }
}
