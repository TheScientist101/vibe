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
    
    var body: some View {
        VStack {
            Toggle("Dark Mode", isOn: $viewModel.darkMode)
        }
        .padding()
    }
}

#Preview {
    Settings()
}
