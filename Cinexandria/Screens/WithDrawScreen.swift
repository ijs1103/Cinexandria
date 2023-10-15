//
//  WithDrawScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/14.
//

import SwiftUI
import PopupView

struct WithDrawScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var floatActive: Bool = false
    
    private func handleButtonClick() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - WithDrawScreen")
            return
        }
        // 소셜로그인 연동해제
        await LoginViewModel.shared.unlink()
        // firestore에서 유저정보 삭제
        UserService.deleteUser(uid: uid)
        // 로컬에서 uid 삭제
        LocalData.shared.userId = nil
        DispatchQueue.main.async {
            self.floatActive = true
        }
    }
    
    var body: some View {
        VStack {
            Text("😢 정말로 탈퇴하시겠습니까?").customFont(size: 22, weight: .bold).padding(.vertical, 12)
            Text("탈퇴시 회원님의 개인정보는 폐기하지만 작성한 리뷰들은 남게 됩니다.").customFont(color: .gray, size: 18, weight: .semibold)
            Spacer()
            Button {
                Task {
                    await handleButtonClick()
                }
            } label: {
                Text("탈퇴").frame(height: 45).frame(maxWidth: .infinity).customFont(color: .white, size: 18, weight: .bold).background(.blue)
            }.cornerRadius(10)
        }.background(.black).padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Constants.NavigationTitle.withDraw)
            .popup(isPresented: $floatActive) {
                SuccessFloat(message: Constants.message.withdraw)
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.spring())
                    .autohideIn(2)
                    .dismissSourceCallback { _ in
                        presentationMode.wrappedValue.dismiss()
                    }
            }
    }
}

