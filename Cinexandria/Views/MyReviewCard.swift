//
//  MyReviewCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/12.
//

import SwiftUI
import PopupView

struct MyReviewCard: View {
    
    let review: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                HStack(alignment: .top, spacing: 12) {
                    NavigationLink(destination: DetailScreen(media: review.mediaType, id: review.workId)) {
                        if let posterURL = review.posterURL {
                            KfManager.downSampledImage(url: posterURL,size: CGSize(width: 60, height: 90)).placeholder {
                                ProgressView()
                            }.imageFill().frame(width: 60, height: 90).cornerRadius(8)
                        } else {
                            Image("NoPoster").imageFill().frame(width: 60, height: 90).cornerRadius(8)
                        }
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text(review.workTitle).customFont(color: .white, size: 14, weight: .bold)
                        Label {
                            Text("\(review.rating)").customFont(color: .yellow, size: 16, weight: .bold)
                        } icon: {
                            Image(systemName: "star.fill").resizable().frame(width: 16, height: 16).foregroundColor(.yellow)
                        }.padding(6).overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(.gray, lineWidth: 1))
                    }.padding(.top, 12)
                }
                Spacer()
                Text(review.createdAt).customFont(color: .gray, size: 16, weight: .medium).padding(.top, 12)
            }
            Text(review.title).customFont(color: Color("BgThird"), size: 18, weight: .bold).padding(.top, 10)
            Text(review.text).customFont(size: 16, weight: .semibold).lineLimit(2)
            Spacer()
        }.frame(height: 200).padding(.horizontal).padding(.vertical, 8).background(Color("BgPrimary")).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)).shadowedStyle()
    }
}
