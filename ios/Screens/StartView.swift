//
//  StartView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/9/25.
//

import SwiftUI

struct StartView: View {
    var onStart: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Text("Vibe")
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .shadow(radius: 10)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.orange, .yellow]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Button(action: onStart) {
                Text("Start a Groove")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 15)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.orange, .yellow]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.black)
                    .cornerRadius(25)
                    .shadow(radius: 10)
            }
        }.preferredColorScheme(.dark)
    }
}


#Preview {
    StartView(onStart: {})
}
