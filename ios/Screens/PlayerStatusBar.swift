//
//  PlayerStatusBar.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI
import MusicKit

struct PlayerStatusBar: View {
    @ObservedObject var playerState: ApplicationMusicPlayer.State

    var body: some View {
        VStack {
            Spacer()
            Text(currentTrackTitle)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundColor(.red)
                .padding(60)
        }
    }

    private var currentTrackTitle: String {
        if playerState.playbackStatus == .playing {
            return ApplicationMusicPlayer.shared.queue.currentEntry?.title ?? "No music playing"
        }
        return "No music playing"
    }
}
