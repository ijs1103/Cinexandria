//
//  MyPageView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI

struct MyPageView: View {
    
    @ObservedObject private var loginVM = LoginViewModel.shared
    
    var body: some View {
        ScrollView {
            Text("마이페이지")
            Button {
                loginVM.logOut()
            } label: {
                Text("로그아웃")
            }
        }
        

    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
    }
}
