//
//  WithDrawScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/14.
//

import SwiftUI

struct WithDrawScreen: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    private func handleButtonClick() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - WithDrawScreen")
            return
        }
        await LoginViewModel.shared.unlink()
        UserService.deleteUser(uid: uid)
        DispatchQueue.main.async {
            presentationMode.wrappedValue.dismiss()
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
    }
}

