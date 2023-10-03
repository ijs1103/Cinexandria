//
//  MyPageView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI

struct MyPageListCellViewModel: Hashable {
    let title: String
    let count: String?
}

struct MyPageView: View {
    
    @ObservedObject private var loginVM = LoginViewModel.shared
    
    let myContents: [MyPageListCellViewModel] = [ MyPageListCellViewModel(title: "작성한 리뷰", count: "5"), MyPageListCellViewModel(title: "찜한 작품", count: "3")]
    
    let infoContents: [MyPageListCellViewModel] = [ MyPageListCellViewModel(title: "정보 수정", count: nil), MyPageListCellViewModel(title: "회원 탈퇴", count: nil)]
    
    var body: some View {
        
        VStack {
            AvatarView(profile: loginVM.profile)
            List {
                Section() {
                    ForEach(myContents, id: \.title) { content in
                        MyPageListCell(content: content)
                    }.listRowBackground(Color("BgDarkGray"))
                }
                Section() {
                    ForEach(infoContents, id: \.title) { content in
                        MyPageListCell(content: content)
                    }.listRowBackground(Color("BgDarkGray"))
                }
                Section() {
                    Button {
                        loginVM.logOut()
                    } label: {
                        Text("로그아웃").frame(maxWidth: .infinity).customFont(color: .white, size: 18, weight: .bold)
                    }.listRowBackground(Color("BgDarkGray"))
                }
            }.listScrollDisable()
        }.task {
            await loginVM.getProfile()
        }
    }
}
