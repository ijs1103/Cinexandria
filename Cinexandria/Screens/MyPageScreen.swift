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
        }.padding().background(.black).task {
            loginVM.loginCheck()
        }.popup(isPresented: $loginVM.loginFloatActive) {
            SuccessFloat(message: Constants.message.signIn)
        } customize: {
            $0.type(.floater())
                .position(.top)
                .animation(.spring())
                .autohideIn(1)
                .dismissCallback {
                    loginVM.loginFloatActive = false
                }
        }.popup(isPresented: $loginVM.logoutFloatActive) {
            SuccessFloat(message: Constants.message.signOut)
        } customize: {
            $0.type(.floater())
                .position(.top)
                .animation(.spring())
                .autohideIn(1)
                .dismissCallback {
                    loginVM.logoutFloatActive = false
                }
        }
    }
}
