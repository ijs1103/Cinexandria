//
//  MyPageScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/27.
//

import SwiftUI
import FirebaseAuth

struct MyPageScreen: View {
    var body: some View {
        ZStack {
            if Auth.auth().currentUser != nil {
                MyPageView()
            } else {
                LoginView()
            }
        }
    }
}
