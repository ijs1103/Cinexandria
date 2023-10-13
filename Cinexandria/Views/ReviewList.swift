//
//  ReviewList.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct ReviewList: View {
    
    let reviews: [ReviewViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(reviews, id: \.id) { review in
                    NavigationLink(destination: ReviewDetailScreen(review: review)) {
                        ReviewCard(review: review)
                    }
                }
            }
        }
    }
}
