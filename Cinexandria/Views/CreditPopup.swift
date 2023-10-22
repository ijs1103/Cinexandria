//
//  CreditPopup.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/22.
//

import SwiftUI

struct CreditPopup: View {
    
    @Binding var isPresented: Bool
    
    let credit: CreditViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top) {
                Spacer()
                Image(systemName: "xmark.circle").imageFill().frame(width: 30, height: 30).foregroundColor(.gray).onTapGesture {
                    self.isPresented = false
                }
            }
            AsyncImage(url: credit.url
                       , content: { phase in
                
                if let image = phase.image {
                    image.imageFill()
                } else {
                    Image("NoPoster").imageFill()
                }
            }).frame(width: 150, height: 150).clipShape(Circle()).overlay(Circle().stroke(Color("BgPrimary"), lineWidth: 2)).padding(.bottom, 12)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("이름").customFont(color: .teal, size: 16, weight: .semibold)
                Text(credit.name).customFont(size: 20, weight: .bold)
                    .padding(.bottom, 8)
                Text("역할").customFont(color: .teal, size: 16, weight: .semibold)
                Text(credit.role).customFont(size: 20, weight: .bold)
            }
        }
        .frame(width: 300)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 12, trailing: 12))
        .background(Color.black.cornerRadius(20))
        .shadowedStyle()
    }
}

