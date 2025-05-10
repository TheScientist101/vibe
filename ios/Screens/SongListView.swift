//
//  SongListView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI
import MusicKit

struct SongListView: View {
    let songs: MusicItemCollection<Song>
    let currentSongID: MusicItemID?
    let isPlaying: Bool
    let onSelect: (Song) -> Void

    var body: some View {
        ScrollView {
            ForEach(songs) { song in
                Button(action: {
                    onSelect(song)
                }) {
                    MusicItemEntry(
                        for: song,
                        isPlaying: currentSongID == song.id && isPlaying
                    )
                }
            }
        }
    }
}

