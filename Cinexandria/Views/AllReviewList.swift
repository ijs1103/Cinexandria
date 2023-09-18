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
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            if reviews.count > 0 {
                ForEach(reviews, id: \.id) { review in
                    AllReviewCard(review: review)
                }
                if reviews.count > 3 {
                    HStack(spacing: 8) {
                        Text("리뷰 \(reviews.count)개 모두 보기").customFont(size: 16, weight: .bold)
                        Image(systemName: "chevron.right").ImageModifier().frame(width: 12, height: 12).foregroundColor(.gray)
                    }.padding(.top, 16)
                }
            } else {
                CustomEmptyView()
            }
        }
    }
}
