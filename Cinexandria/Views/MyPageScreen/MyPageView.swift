//
//  MyPageView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI

struct MyPageListCellViewModel {
    let title: String
    let count: Int?
    let destination: AnyView
}

struct MyPageView: View {
    
    @ObservedObject private var loginVM = LoginViewModel.shared
    @ObservedObject private var myPageVM = MyPageViewModel()
    
    var body: some View {
        VStack {
            AvatarView(profile: loginVM.profile)
            List {
                Section() {
                    ForEach(myPageVM.myContents, id: \.title) { content in
                        // navigationlink로 감쌀시 생성되는 disclosure 제거 
                        ZStack {
                            NavigationLink(destination: content.destination) {
                                MyPageListCell(content: content)
                            }.opacity(0)
                            HStack {
                                MyPageListCell(content: content)
                            }
                        }
                    }.listRowBackground(Color("BgDarkGray"))
                }
                Section() {
                    ForEach(myPageVM.infoContents, id: \.title) { content in
                        ZStack {
                            NavigationLink(destination: content.destination) {
                                MyPageListCell(content: content)
                            }.opacity(0)
                            HStack {
                                MyPageListCell(content: content)
                            }
                        }
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
