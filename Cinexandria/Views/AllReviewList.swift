//
//  AllReviewList.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/14.
//

import SwiftUI

struct AllReviewList: View {
    
    // 리뷰 3개만 보여주고 모두 보기 누르면 AllReviewScreen으로 이동하기 구현
    let reviews: [ReviewViewModel]
    
    let reviewCount: Int
    
    let workId: Int
    
    var body: some View {
        VStack(spacing: 10) {
            if reviewCount > 0 {
                ForEach(reviews, id: \.id) { review in
                    NavigationLink(destination: ReviewDetailScreen(review: review)) {
                        AllReviewCard(review: review)
                    }
                }
                if reviewCount > 3 {
                    NavigationLink(destination: AllReviewScreen(workId: workId)) {
                        HStack(spacing: 8) {
                            Text("리뷰 \(reviewCount)개 모두 보기").customFont(size: 16, weight: .bold)
                            Image(systemName: "chevron.right").imageFit().frame(width: 12, height: 12).foregroundColor(.gray)
                        }.padding(.top, 16)
                    }
                }
            } else {
                CustomEmptyView()
            }
        }
    }
}
