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
import NaverThirdPartyLogin


struct AuthProfileViewModel {
    let name: String
    let photoURL: URL?
}

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
    
    static let shared = LoginViewModel()
    //private init() {}
    
    @Published var authProfile: AuthProfileViewModel?
    
    private var currentNonce: String?
    
    func logOut() {
        // 구글, 애플 로그아웃
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print("Error signing out - Firebase", signOutError)
            }
        }
        // 네이버 로그아웃
        if ((NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken) != nil) {
            NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
        }
    }
    
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
    
    func appleSignIn() {
        AppleSignIn.shared.appleSignIn()
        DispatchQueue.main.async {
            self.authProfile = AuthProfileViewModel(name: "애플 유저", photoURL: nil)
        }
    }
    
    func naverSignIn() {
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = self
        NaverThirdPartyLoginConnection
            .getSharedInstance()
            .requestThirdPartyLogin()
    }
    
}

extension LoginViewModel: UIApplicationDelegate, NaverThirdPartyLoginConnectionDelegate {
    
    private func getNaverUserInfo() async throws -> Response? {
        let loginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        guard let isValidAccessToken = loginInstance?.isValidAccessTokenExpireTimeNow() else { return nil }
        if !isValidAccessToken {
            return nil
        }
        guard let tokenType = loginInstance?.tokenType else { return nil }
        guard let accessToken = loginInstance?.accessToken else { return nil }
        let authorization = "\(tokenType) \(accessToken)"
        guard let url = URL(string: "https://openapi.naver.com/v1/nid/me") else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(NaverInfoResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.response
    }
    
    // 로그인에 성공시
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("[Success] : Success Naver Login")
        Task {
            do {
                let info = try await getNaverUserInfo()
                let photoURL = URL(string: info!.profileImage) ?? nil
                DispatchQueue.main.async {
                    self.authProfile = AuthProfileViewModel(name: info?.nickname ?? "네이버 유저", photoURL: photoURL)
                }
            } catch NetworkError.badDecoding {
                print("trending movie error - badDecoding")
            } catch NetworkError.badServer {
                print("trending movie error - badServer")
            }
        }
        
        
    }
    
    // 토큰 갱신시
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    
    // 로그아웃 했을때
    func oauth20ConnectionDidFinishDeleteToken() {
        NaverThirdPartyLoginConnection.getSharedInstance()?.requestDeleteToken()
    }
    
    // 에러 발생시
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("[Error] :", error.localizedDescription)
    }
}

