//
//  MusicItemEntry.swift
//  vibe
//
//  Created by Urjith Mishra on 5/8/25.
//

import SwiftUI
import MusicKit

struct MusicItemEntry: View {
    private let player: ApplicationMusicPlayer = ApplicationMusicPlayer.shared
    
    private let name: String
    private let playable: PlayableMusicItem
    private let artist: String?
    private let artwork: Artwork?
    
    init(for album: Album) {
        playable = album
        name = album.title
        artist = album.artistName
        artwork = album.artwork
    }
    
    init (for playlist: Playlist) {
        playable = playlist
        name = playlist.name
        artist = playlist.curator?.name
        artwork = playlist.artwork
    }
    
    init (for song: Song) {
        playable = song
        name = song.title
        artist = song.artistName
        artwork = song.artwork
    }
    
    var body: some View {
        Button(action: play) {
            Text(name)
        }
    }
    
    private func play() -> Void {
        Task {
            player.queue = [playable]
            try await player.play()
        }
    }
}
