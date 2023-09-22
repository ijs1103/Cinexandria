//
//  ScrollTopButton.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/22.
//

import SwiftUI

struct ScrollTopButton: View {
    
    let onClick: () -> Void
    
    init(onClick: @escaping () -> Void) {
        self.onClick = onClick
    }
    
    var body: some View {
        Button(action: {
            onClick()
        }, label: {
            Image(systemName: "arrow.up")
                .font(.system(size: 30))
                .foregroundColor(.white)
                .padding()
                .background(Color("BgThird"))
                .clipShape(Circle())
                .overlay(Circle().opacity(0.1))
                .overlay(Circle().stroke(.white, lineWidth: 4))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
        }).padding(.trailing)
            .padding(.bottom, Theme.getSafeArea().bottom == 0 ? 12 : 0)
    }
}
