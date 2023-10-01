//
//  CinexandriaApp.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/04.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import NaverThirdPartyLogin
import KakaoSDKCommon
import KakaoSDKAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CinexandriaApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var appState = AppState()
    
    init() {
        Theme.navigationBarColors(background: UIColor(Color("BgPrimary")), titleColor: UIColor(Color("FontPrimary")))
        Theme.tabBarColors(background: UIColor(Color("BgPrimary")), tintColor: UIColor(Color("FontPrimary")))
        Theme.searchBarColors(background: UIColor(Color("BgThird")), tintColor: .white)
        // 네이버 앱으로 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
        // 브라우저 로그인 허용
        NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true
        // 네이버 로그인 세로모드 고정
        NaverThirdPartyLoginConnection.getSharedInstance().setOnlyPortraitSupportInIphone(true)
        // NaverThirdPartyConstantsForApp.h에 선언한 상수 등록
        NaverThirdPartyLoginConnection.getSharedInstance().serviceUrlScheme = kServiceAppUrlScheme
        NaverThirdPartyLoginConnection.getSharedInstance().consumerKey = kConsumerKey
        NaverThirdPartyLoginConnection.getSharedInstance().consumerSecret = kConsumerSecret
        NaverThirdPartyLoginConnection.getSharedInstance().appName = kServiceAppName
        KakaoSDK.initSDK(appKey: Constants.kakaoAppKey)
    }
    
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack(path: $appState.routes) {
                    HomeScreen().onOpenURL { url in
                        // Token 발급 요청
                        if let naverInstance = NaverThirdPartyLoginConnection
                            .getSharedInstance() {
                            naverInstance.receiveAccessToken(url)
                        }
                        
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            _ = AuthController.handleOpenUrl(url: url)
                        }
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        HomeScreen()
                    case .login:
                        EmptyView()
                    case .signup:
                        EmptyView()
                    }
                }.tint(.white).foregroundColor(Color("FontPrimary")).environmentObject(appState)
            }
            else {
                HomeScreen()
            }
        }
        
    }
}
