//
//  AllReviewCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/14.
//

import SwiftUI

struct AllReviewCard: View {
    
    let review: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label {
                    Text("\(review.nickname)").customFont(size: 16, weight: .bold)
                } icon: {
                    AsyncImage(url: review.avatarURL
                               , content: { phase in
                        if let image = phase.image {
                            image.imageFit().clipShape(Circle()).clipped()
                        } else {
                            Image("NoPoster").imageFit().clipShape(Circle()).clipped()
                        }
                    }).frame(width: 40, height: 40)
                }
                Spacer()
                Text(review.createdAt).customFont(color: .gray, size: 16, weight: .medium)
            }
            Label {
                Text("\(review.rating)").customFont(color: .yellow, size: 18, weight: .bold)
            } icon: {
                Image(systemName: "star.fill").resizable().frame(width: 18, height: 18).foregroundColor(.yellow)
            }.padding(6).overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(.gray, lineWidth: 1))
            Text(review.title).customFont(color: Color("BgThird"), size: 18, weight: .bold).padding(.top, 10)
            Text(review.text).customFont(color: .gray, size: 16, weight: .semibold).lineLimit(2)
            Spacer()
        }.frame(height: 190).padding(.horizontal).padding(.vertical, 8).background(Color("BgPrimary")).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
