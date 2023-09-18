//
//  ReviewCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import SwiftUI

struct ReviewCard: View {
    let review: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(review.workTitle).font(.system(size: 14, weight: .semibold)).lineLimit(1)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").resizable().frame(width: 14, height: 14)
                    Text(review.rating).font(.system(size: 14, weight: .semibold))
                }.foregroundColor(.teal)
            }
            Text(review.title).font(.system(size: 16, weight: .bold)).foregroundColor(.white).padding(EdgeInsets(top: 4, leading: 0, bottom: 10, trailing: 0)).lineLimit(2)
            Text("\(review.reviewerName)님의 리뷰").font(.system(size: 12, weight: .semibold)).lineLimit(1).foregroundColor(.gray)
        }
        .frame(maxWidth: 250)
        .padding()
        .background(Color("BgPrimary"))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}
