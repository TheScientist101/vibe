//
//  ContentView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showStartScreen: Bool = true
    
    var body: some View {
        SearchMusicView()
            .fullScreenCover(isPresented: $showStartScreen) {
                VStack(spacing: 40) {
                    Text("Vibe")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .shadow(radius: 10)
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    
                    Button(action: startGroove) {
                        Text("Start a Groove")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 15)
                            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .foregroundColor(.black)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                }
            }.preferredColorScheme(ColorScheme.dark)
    }
    
    private func startGroove() -> Void {
        showStartScreen.toggle()
    }
}

#Preview {
    ContentView()
}
