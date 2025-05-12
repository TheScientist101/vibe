//
//  MusicProviderSelector.swift
//  vibe
//
//  Created by Jayden Chun on 5/10/25.
//

import Foundation
import SwiftUI
struct MusicProviderSelector : View {
    @Published var musicProviderSpotify = false;
    var body: some View{
        VStack{
            Text("Select Your Music Provider:")
            HStack{
                Button(action: {musicProviderSpotify = true; print(musicProviderSpotify)
                    }){
                    Image("SpotifyLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                Button(action: {musicProviderSpotify = false;
                    
                    print(musicProviderSpotify);
                    }) {
                    Image("AppleMusicLogo")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
    
    
}
#Preview{
    MusicProviderSelector()
}
