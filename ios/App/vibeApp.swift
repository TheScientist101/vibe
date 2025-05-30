//
//  vibeApp.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI

@main
struct vibeApp: App {
//    let controller = ViewController()
    var body: some Scene {
        WindowGroup {
//            ContentView(musicProvider: .apple, remoteDelegate: controller, appRemotes: controller.appRemote, connected: false)
            ContentView(musicProvider: .apple)
        }
    }
}
