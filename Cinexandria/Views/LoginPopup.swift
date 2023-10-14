//
//  LoginPopup.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/14.
//

import SwiftUI

struct LoginPopup: View {
    
    @Binding var isPresented: Bool 

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                Spacer()
                Image(systemName: "xmark.circle").imageFill().frame(width: 30, height: 30).foregroundColor(.gray).onTapGesture {
                    self.isPresented = false
                }
            }
            Text("로그인 후 사용할 수 있어요.")
                .foregroundColor(.black)
                .font(.system(size: 20))
                .padding(.bottom, 20)
            
            HStack(spacing: 10) {
                Button("건너뛰기") {
                    self.isPresented = false
                }
                .buttonStyle(.plain)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 24)
                .foregroundColor(.gray)
                .background(Color("BgDarkGray"))
                .cornerRadius(12)
                NavigationLink(destination: MyPageScreen()) {
                    Button("로그인") {}
                    .buttonStyle(.plain)
                    .font(.system(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 24)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(12)
                }
            }
        }
        .frame(width: 250)
        .padding(EdgeInsets(top: 16, leading: 24, bottom: 40, trailing: 24))
        .background(Color.white.cornerRadius(20))
        .shadowedStyle()
        .padding(.horizontal, 40)
    }
}
