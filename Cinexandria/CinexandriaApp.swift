//
//  CinexandriaApp.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/04.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

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
        UITabBar.appearance().backgroundColor = UIColor(Color("BgPrimary"))
        UITabBar.appearance().barTintColor = UIColor(Color("FontPrimary"))
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color("FontPrimary"))]
    }
    
    
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16.0, *) {
                NavigationStack(path: $appState.routes) {
                    HomeScreen()
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .main:
                        HomeScreen()
                    case .login:
                        EmptyView()
                    case .signup:
                        EmptyView()
                    }
                }.foregroundColor(Color("FontPrimary")).environmentObject(appState)
            }
            else {
                EmptyView()
            }
        }
        
    }
}
