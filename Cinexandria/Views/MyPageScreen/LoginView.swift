//
//  LoginView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @ObservedObject private var loginVM = LoginViewModel.shared
    
    init() {
        loginVM.setupGoogleConfig()
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(Constants.mainTitle).customFont(size: 32, weight: .heavy).padding(.bottom, 80)
            VStack(spacing: 12) {
                SocialLoginButton(provider: .kakao)
                SocialLoginButton(provider: .naver)
                SocialLoginButton(provider: .google)
                SocialLoginButton(provider: .apple)
            }.padding(.bottom, 60)
        }.padding()
            .background(.black)
            .navigationWrapper()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
