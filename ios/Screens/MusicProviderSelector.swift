//
//  MusicProviderSelector.swift
//  vibe
//
//  Created by Jayden Chun on 5/10/25.
//

import Foundation
import SwiftUI


struct MusicProviderSelector : View {
    @Binding var firstPickup: Bool
    @State var musicProviderSpotify = false;
    var body: some View{
        VStack{
            Text("Select Your Music Provider:")
            Button(action: {musicProviderSpotify = true;
                firstPickup = false;
                print(musicProviderSpotify)}){
                    Text("Spotify")
            }
            .padding()
            .foregroundStyle(.white)
            .padding(.horizontal, 30)
            .background(.green)
            .cornerRadius(10)
            .bold()
            
            Button(action: {musicProviderSpotify = false;
                firstPickup = false;
                print(musicProviderSpotify)}){
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
#Preview{
    MusicProviderSelector(firstPickup : .constant(true))
}
