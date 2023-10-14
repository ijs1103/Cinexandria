//
//  SuccessFloat.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/14.
//

import SwiftUI

struct SuccessFloat: View {
    let message: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image("checkmark")
                .frame(width: 48, height: 48)
                .cornerRadius(24)
            Text(message)
                .customFont(color: .black, size: 22, weight: .bold)
            Spacer()
        }
        .foregroundColor(.black)
        .padding(16)
        .padding(.horizontal, 16)
        .background(Color.white.cornerRadius(12))
        .shadow(color: .black.opacity(0.1), radius: 40, x: 0, y: -4)
    }
}
