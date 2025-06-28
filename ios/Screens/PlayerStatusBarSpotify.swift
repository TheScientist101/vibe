//
//  PlayerStatusBarSpotify.swift
//  vibe
//
//  Created by Jayden Chun on 6/16/25.
//

import SwiftUI

struct PlayerStatusBarSpotifyPrecise: View {
    @ObservedObject var manager = SpotifyManager.shared
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                HStack(spacing: 12) {
                    AsyncImage(url: URL(string: manager.currentTrack?.album.imageUrl ?? "")) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.gray.opacity(0))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.leading, 8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(manager.currentTrack?.name ?? "")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .medium))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text(manager.currentTrack?.artistName ?? "")
                            .foregroundColor(.gray)
                            .font(.system(size: 11))
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    if let _ = manager.currentTrack?.name {
                        Button(action: {
                            manager.currentTrackPlaying = !manager.currentTrackPlaying
                            print("is current track playing? -> " + String(manager.currentTrackPlaying))
                            !manager.currentTrackPlaying ? manager.handlePausePressed(track: manager.currentTrack!) : manager.handleResumePressed(track: manager.currentTrack!)
                        }) {
                            Image(systemName: manager.currentTrackPlaying ? "pause.fill" : "play.fill")
                                .foregroundStyle(.white)
                                .font(.system(size: 20))
                        }
                        .frame(width: 44, height: 44)
                    }
                }
                .padding(.top, 8)
                .background(Color.black)
                .cornerRadius(8)
                .offset(y: keyboardHeight > 0 ? -keyboardHeight + geometry.safeAreaInsets.bottom : -1 * geometry.safeAreaInsets.bottom*1.71)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
            }
        }
    }
}
