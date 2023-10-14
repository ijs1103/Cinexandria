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
            HStack(alignment: .top) {
                HStack(alignment: .top, spacing: 12) {
                    AsyncImage(url: review.posterURL
                               , content: { phase in
                        if let image = phase.image {
                            image.imageFill().cornerRadius(8)
                        } else if phase.error != nil {
                            Image("NoPoster").imageFill().cornerRadius(8)
                        } else {
                            ProgressView()
                        }
                    }).frame(width: 60, height: 90)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(review.workTitle).customFont(color: .white, size: 16, weight: .bold)
                        HStack(spacing: 8) {
                            Text("\(review.nickname)님의 리뷰").customFont(color: .gray, size: 12, weight: .bold)
                            Label {
                                Text("\(review.rating)").customFont(color: .yellow, size: 14, weight: .bold)
                            } icon: {
                                Image(systemName: "star.fill").resizable().frame(width: 14, height: 14).foregroundColor(.yellow)
                            }.padding(4).overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(.gray, lineWidth: 1))
                        }
                    }.padding(.top, 12)
                }
                Spacer()
                Text(review.createdAt).customFont(color: .gray, size: 16, weight: .medium).padding(.top, 12)
            }.padding(.top, 12)
            
            Text(review.title).customFont(color: Color("BgThird"), size: 18, weight: .bold).padding(.top, 10)
            Text(review.text).customFont(size: 16, weight: .semibold).lineLimit(2)
            Spacer()
        }.frame(height: 200).padding(.horizontal).padding(.vertical, 8).background(Color("BgPrimary")).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)).shadowedStyle()
    }
}
