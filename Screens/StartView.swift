//
//  StartView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/8/25.
//

import SwiftUI

struct StartView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 40) {
                Text("Vibe")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .shadow(radius: 10)
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.yellow]), startPoint: .topLeading, endPoint: .bottomTrailing))
                
                Button(action: {SearchMusicView()}) {
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
        }
    }
}

#Preview {
    StartView()
}
