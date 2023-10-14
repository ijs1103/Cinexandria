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
import KakaoSDKUser
import KakaoSDKAuth

@MainActor
final class LoginViewModel: NSObject, ObservableObject {
    
    static let shared = LoginViewModel()
    @Published var profile: User?
    @Published var isLoggined: Bool = false
    @Published var loginFloatActive: Bool = false
    @Published var logoutFloatActive: Bool = false
    private var currentNonce: String?

    func loginCheck() {
        DispatchQueue.main.async {
            self.isLoggined = Auth.auth().currentUser != nil || NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken != nil || AuthApi.hasToken()
        }
    }
    
    func getProfile() async {
        // 로컬에 저장된 uid를 통해 firebase에서 유저 정보를 fetch
        guard let uid = LocalData.shared.userId else { return }
        do {
            let profile = try await UserService.getUser(uid: uid)
            DispatchQueue.main.async {
                self.profile = profile
            }
        } catch FirebaseError.dataEmpty {
            print("no data - getProfile")
        } catch {
            print("unknown error - getProfile")
        }
    }
    
    func logOut() {
        // Firebase(구글, 애플) 로그아웃
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                self.isLoggined = false
            } catch let signOutError as NSError {
                print("Error signing out - Firebase", signOutError)
            }
        }
        // 네이버 로그아웃
        if ((NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken) != nil) {
            NaverThirdPartyLoginConnection.getSharedInstance().resetToken()
            self.isLoggined = false
        }
        // 카카오 로그아웃
        if AuthApi.hasToken() {
            UserApi.shared.logout { error in
                if let error = error {
                    print("카카오 로그아웃 에러: \(error.localizedDescription)")
                } else {
                    self.isLoggined = false
                }
            }
        }
        // 로컬에서 uid 삭제
        LocalData.shared.userId = nil
        self.logoutFloatActive = true
    }
    
    func setUserToFirebaseAndLocal(data: [String : Any]) {
        UserService.setUser(data: data as [String : Any])
        LocalData.shared.userId = data["uid"] as? String
    }
    
    func setupGoogleConfig() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
    }
    
    func googleSignIn() async {
        guard let rootVC = Utils.shared.getRootVC() else {
            print("Cannot get ViewController")
            return
        }
        do {
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootVC)
            guard let idToken = result.user.idToken?.tokenString else {
                print("Cannot get id token")
                return
            }
            let accessToken = result.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            let authResult = try await Auth.auth().signIn(with: credential)
            guard let displayName = authResult.user.displayName, let photoURL = authResult.user.photoURL else {
                print("Cannot get credential")
                return
            }
            guard let uid = Auth.auth().currentUser?.uid else {
                print("empty uid - firebaseauth")
                return
            }
            let data = ["uid": uid, "photoURL": photoURL.absoluteString, "nickname": displayName]
            self.setUserToFirebaseAndLocal(data: data)
        } catch {
            print("firebase error - googleSignIn")
            return
        }
        DispatchQueue.main.async {
            self.loginFloatActive = true
            self.isLoggined = true
        }
    }
    
    func appleSignIn() {
        AppleSignIn.shared.appleSignIn()
    }
    
    func naverSignIn() {
        NaverThirdPartyLoginConnection.getSharedInstance().delegate = self
        NaverThirdPartyLoginConnection
            .getSharedInstance()
            .requestThirdPartyLogin()
    }
    
    private func kakaoWork(_ error: Error?) {
        if let error = error {
            print("카카오 로그인 에러: \(error.localizedDescription)")
        } else {
            UserApi.shared.me { User, Error in
                guard let kakaoAccount = User?.kakaoAccount else {
                    print("cannot get kakao user info")
                    return
                }
                let nickname = kakaoAccount.profile?.nickname ?? "카카오 유저"
                let photoURL = kakaoAccount.profile?.profileImageUrl?.absoluteString
                let email = kakaoAccount.email
                let data = ["uid": email, "photoURL": photoURL, "nickname": nickname]
                self.setUserToFirebaseAndLocal(data: data as [String : Any])
                DispatchQueue.main.async {
                    self.loginFloatActive = true
                    self.isLoggined = true
                }
            }
        }
    }
    func kakaoSignIn() {
        
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(_, error) in
                self.kakaoWork(error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount {(_, error) in
                self.kakaoWork(error)
            }
        }
    }
    
    func unlink() {
        // Firebase(구글, 애플) 연동해제
        if let user = Auth.auth().currentUser {
            user.delete()
        }
        // 네이버 연동해제
        if ((NaverThirdPartyLoginConnection.getSharedInstance()?.accessToken) != nil) {
            NaverThirdPartyLoginConnection.getSharedInstance().requestDeleteToken()
        }
        // 카카오 연동해제
        if AuthApi.hasToken() {
            UserApi.shared.unlink { error in
                if let error = error {
                    print("카카오 연동해제 에러: \(error.localizedDescription)")
                }
            }
        }
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
                guard let info = try await getNaverUserInfo() else {
                    print("cannot get naver user info")
                    return
                }
                let data = ["uid": info.email, "photoURL": info.profileImage, "nickname": info.nickname]
                self.setUserToFirebaseAndLocal(data: data)
                DispatchQueue.main.async {
                    self.loginFloatActive = true
                    self.isLoggined = true
                }
            } catch NetworkError.badDecoding {
                print("naver user info error - badDecoding")
            } catch NetworkError.badServer {
                print("naver user info error - badServer")
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

