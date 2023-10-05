//
//  CreditList.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/13.
//

import SwiftUI

struct CreditList: View {
    
    @State private var isMoreTapped: Bool = false

    let credits: [CreditViewModel]?
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        if let credits = credits, !credits.isEmpty {
            VStack(spacing: 14) {
                LazyVGrid(columns: columns) {
                    ForEach(!isMoreTapped ? Array(credits.prefix(4)) : credits, id: \.id) { credit in
                        VStack(spacing: 0){
                            AsyncImage(url: credit.url
                                       , content: { phase in
                                
                                if let image = phase.image {
                                    image.imageFit().clipShape(Circle()).overlay(Circle().stroke(Color("BgPrimary"), lineWidth: 2)).clipped()
                                } else {
                                    Image("NoPoster").imageFit().clipShape(Circle()).overlay(Circle().stroke(Color("BgPrimary"), lineWidth: 2)).clipped()
                                }
                            })
                            Text(credit.name).customFont(size: 14, weight: .bold).lineLimit(1).padding(.bottom, 4)
                            Text(credit.role).customFont(color: .gray, size: 14, weight: .semibold).lineLimit(1)
                        }
                    }
                }
                HStack(spacing: 0) {
                    Text(isMoreTapped ? "접기 " : "더보기 ")
                    Image(systemName: isMoreTapped ? "chevron.up" : "chevron.down")
                }.onTapGesture {
                    isMoreTapped.toggle()
                }
            }
        } else {
            CustomEmptyView()
        }
    }
}

