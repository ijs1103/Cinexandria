//
//  MyPageScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI
import FirebaseAuth

struct MyPageScreen: View {
    @ObservedObject private var loginVM = LoginViewModel.shared
    
    var body: some View {
        ZStack {
            if loginVM.isLoggined {
                MyPageView()
            } else {
                LoginView()
            }
        }
    }
}
