//
//  LoginViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

struct AuthProfileViewModel {
    let name: String
    let photoURL: URL?
}

@MainActor
final class LoginViewModel: ObservableObject {
    
    static let shared = LoginViewModel()
    private init() {}
    
    @Published var authProfile: AuthProfileViewModel?
    
    func setupGoogleConfig() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    func googleSignIn() async throws {
        guard let rootVC = Utils.shared.getRootVC() else { throw URLError(.cannotFindHost) }
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
        guard let idToken = result.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = result.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        let authResult = try await Auth.auth().signIn(with: credential)
        guard let displayName = authResult.user.displayName, let photoURL = authResult.user.photoURL else {
            throw NetworkError.badCredential
        }
        DispatchQueue.main.async {
            self.authProfile = AuthProfileViewModel(name: displayName, photoURL: photoURL)
        }
    }
}


