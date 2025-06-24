//
//  Settings.swift
//  vibe
//
//  Created by Jayden Chun on 5/12/25.
//

import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var darkMode: Bool = false
}

struct Settings: View {
    @StateObject private var viewModel = SettingsViewModel()
    @State private var appleMusic = true
    @AppStorage("musicProvider") var musicProvider: MusicProvider = true ? .apple : .spotify
    var body: some View {
        VStack {
            if(musicProvider == .apple)
            {
                Toggle("Apple Music", isOn: $appleMusic)
                    .onChange(of: appleMusic) {
                        musicProvider = appleMusic ? .apple : .spotify
                        print("current music provider is " + String(musicProvider == .apple ? "Apple" : "Spotify"))
                    }
                    .tint(Color.pink)
            }
            else {
                Toggle("Spotify", isOn: $appleMusic)
                    .onChange(of: appleMusic) {
                        musicProvider = appleMusic ? .spotify : .apple
                        print("current music provider is " + String(musicProvider == .apple ? "Apple" : "Spotify"))
                    }
                    .tint(Color.green)
            }
        }
        .padding()
    }
}

#Preview {
    Settings()
}
