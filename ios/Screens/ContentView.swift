//
//  ContentView.swift
//  vibe
//
//  Created by Urjith Mishra on 5/7/25.
//

import SwiftUI
import MusicKit

public enum MusicProvider: String{
    case spotify
    case apple
}

struct ConnectButtonWrapper: UIViewRepresentable {
    let connectButton: UIButton
    
    func makeUIView(context: Context) -> UIButton {
        return connectButton
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        
    }
}

struct ContentView: View {
    @State private var showStartScreen: Bool = true
    @AppStorage("firstPickup") private var firstPickup = true
    @AppStorage("musicProvider") var musicProvider: MusicProvider = .apple
    @ObservedObject private var playerState = ApplicationMusicPlayer.shared.state

    var body: some View {
        ZStack {
            if firstPickup {
                MusicProviderSelector(
                    firstPickup : $firstPickup,
                    musicProvider: musicProvider)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black)
                    .ignoresSafeArea()
                    .zIndex(3)
                    .transition(.opacity)
            }
            if !firstPickup && musicProvider == .spotify{
                SignInButton()
                    .zIndex(4)
                    .frame(width: 120, height: 50)
                    .foregroundStyle(.white)
                    .bold()
                    .cornerRadius(20)
            }
            if musicProvider == .apple {
                MainTabView()
                PlayerStatusBar(playerState: playerState)
            }
            else {
                MainTabView()
                PlayerStatusBarSpotify()
            }
            
        }
        .fullScreenCover(isPresented: $showStartScreen) {
            StartView(onStart: startGroove)
        }
    }

    private func startGroove() {
        showStartScreen = false
        firstPickup = true
    }
}
struct SignInButton: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> SignInViewController {
        return SignInViewController()
    }
    
    func updateUIViewController(_ uiViewController: SignInViewController, context: Context) {
    }
}


class SignInViewController: UIViewController {
    @AppStorage("spotifyAccessToken") var spotifyAccessToken : String = ""
    @ObservedObject var manager = SpotifyManager.shared
    private var signInButton: UIButton!
    private var clicked: Bool = false {
        didSet {
            if clicked {
                signInButton?.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInButton()
    }
    
    private func setupSignInButton() {
        signInButton = UIButton(type: .system)
        if clicked{
            signInButton.isHidden = true
        }
        else {
            signInButton.setTitle("Connect to Spotify", for: .normal)
            signInButton.setTitleColor(.white, for: .normal)
            signInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            signInButton.configuration?.titlePadding = 30
            signInButton.backgroundColor = .systemGreen
            
            signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
            
            view.addSubview(signInButton)
            signInButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                signInButton.topAnchor.constraint(equalTo: view.topAnchor),
                signInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    
    @objc func signIn(_ sender: Any) {
        let bundleIdentifier = Bundle.main.bundleIdentifier!
        let spotifyClientId = Bundle.main.object(forInfoDictionaryKey: "SpotifyClientId") as! String
        let authorizeURL = "https://accounts.spotify.com/authorize"
        let tokenURL = "https://accounts.spotify.com/api/token"
        let redirectUri = "\(bundleIdentifier)://callback"
        let parameters = OAuth2PKCEParameters(
            authorizeUrl: authorizeURL,
            tokenUrl: tokenURL,
            clientId: spotifyClientId,
            redirectUri: redirectUri,
            callbackURLScheme: bundleIdentifier
        )
        
        let authenticator = OAuth2PKCEAuthenticator()
        authenticator.authenticate(parameters: parameters) { result in
            switch result {
            case .success(let accessTokenResponse):
                self.spotifyAccessToken = accessTokenResponse.access_token
                self.manager.spotifyAccessToken = self.spotifyAccessToken
            case .failure(let error):
                print("Spotify Auth Error: \(error)")
            }
        }
        
        
        
        clicked = true
        print(clicked)
    }
}


