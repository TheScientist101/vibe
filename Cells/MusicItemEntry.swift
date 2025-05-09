import SwiftUI
import MusicKit

struct MusicItemEntry: View {
    private let name: String
    private let playable: PlayableMusicItem
    private let artist: String?
    private let artwork: Artwork?
    public let isPlaying: Bool
    
    init(for album: Album, isPlaying: Bool) {
        playable = album
        name = album.title
        artist = album.artistName
        artwork = album.artwork
        self.isPlaying = isPlaying
    }
    
    init(for playlist: Playlist, isPlaying: Bool) {
        playable = playlist
        name = playlist.name
        artist = playlist.curator?.name
        artwork = playlist.artwork
        self.isPlaying = isPlaying
    }
    
    init(for song: Song, isPlaying: Bool) {
        playable = song
        name = song.title
        artist = song.artistName
        artwork = song.artwork
        self.isPlaying = isPlaying
    }
    
    var body: some View {
        HStack(spacing: 12) {
            if let artwork, let url = artwork.url(width: 256, height: 256) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                if let artist {
                    Text(artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Image(systemName:
                    isPlaying ? "pause.circle.fill" : "play.circle.fill")
                .font(.title2)
                .foregroundColor(.accentColor)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
