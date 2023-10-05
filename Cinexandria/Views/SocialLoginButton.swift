//
//  SocialLoginButton.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI

struct SocialLoginButton: View {
    
    @EnvironmentObject private var appState: AppState
    @ObservedObject private var loginVM = LoginViewModel.shared
    
    let provider: Provider
    
    var body: some View {
        Button(action: {
            switch provider {
            case .google:
                Task {
                    do {
                        try await loginVM.googleSignIn()
                    } catch URLError.cannotFindHost {
                        print("Cannot get ViewController")
                    } catch URLError.badServerResponse {
                        print("Cannot get id token")
                    } catch NetworkError.badCredential {
                        print("Cannot get credential")
                    }
                }
            case .apple:
                loginVM.appleSignIn()
            case .naver:
                loginVM.naverSignIn()
            case .kakao:
                loginVM.kakaoSignIn()
            }
        }) {
            HStack(alignment: .center) {
                Image(provider.buttonImageName).imageFit().frame(height: 36)
                Spacer()
                Text(provider.buttonTitle)
                    .fontWeight(.semibold)
                Spacer()
            }
        }.padding(10).foregroundColor(provider.buttonTextColor)
            .background(provider.buttonBgColor).cornerRadius(12).overlay(
            RoundedRectangle(cornerRadius: 12).stroke(provider.buttonBorderColor, lineWidth: 1)
        )
    }
}

struct SocialLoginButton_Previews: PreviewProvider {
    static var previews: some View {
        SocialLoginButton(provider: .apple)
    }
}

enum Provider {
    case kakao, naver, google, apple
    var buttonTitle: String {
        switch self {
        case .apple:
            return "애플로 시작하기"
        case .google:
            return "구글로 시작하기"
        case .kakao:
            return "카카오로 시작하기"
        case .naver:
            return "네이버로 시작하기"
        }
    }
    var buttonImageName: String {
        switch self {
        case .apple:
            return "logo_apple"
        case .google:
            return "logo_google"
        case .kakao:
            return "logo_kakao"
        case .naver:
            return "logo_naver"
        }
    }
    var buttonBorderColor: Color {
        switch self {
        case .apple, .google:
            return .white
        default:
            return .clear
        }
    }
    var buttonTextColor: Color {
        switch self {
        case .kakao:
            return .black
        default:
            return .white
        }
    }
    var buttonBgColor: Color {
        switch self {
        case .apple, .google:
            return .clear
        case .kakao:
            return .yellow
        case .naver:
            return .green
        }
    }
}
