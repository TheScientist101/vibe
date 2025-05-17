//
//  SpotifyController.swift
//  vibe
//
//  Created by Jayden Chun on 5/13/25.
//

import Foundation
let SpotifyClientID = "[your spotify client id here]"
let SpotifyRedirectURL = URL(string: "spotify-ios-quick-start://spotify-login-callback")!

lazy var configuration = SPTConfiguration(
  clientID: SpotifyClientID,
  redirectURL: SpotifyRedirectURL
)

func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
  let parameters = appRemote.authorizationParameters(from: url);

        if let access_token = parameters?[SPTAppRemoteAccessTokenKey] {
            appRemote.connectionParameters.accessToken = access_token
            self.accessToken = access_token
        } else if let error_description = parameters?[SPTAppRemoteErrorDescriptionKey] {
            // Show the error
        }
  return true
}

class AppDelegate: UIResponder, UIApplicationDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
      print("connected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
      print("disconnected")
    }
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
      print("failed")
    }
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
      print("player state changed")
    }

}

lazy var appRemote: SPTAppRemote = {
  let appRemote = SPTAppRemote(configuration: self.configuration, logLevel: .debug)
  appRemote.connectionParameters.accessToken = self.accessToken
  appRemote.delegate = self
  return appRemote
}()
