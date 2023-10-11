//
//  RecentReviewViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/11.
//

import Foundation
import FirebaseFirestore

final class RecentReviewViewModel: ObservableObject {
    @Published var reviews: [ReviewViewModel] = []
    private var currentQuery: Query? = nil
    
    func load() async {
        let firstQuery = ReviewService.getFirstRecentReviewsQuery()
        self.currentQuery = firstQuery
        
        guard let reviews = await ReviewService.convertReviewQueryToReviwVM(query: firstQuery) else {
            print("decode error - RecentReviewViewModel load")
            return
        }
        
        DispatchQueue.main.async {
            self.reviews = reviews
        }
    }
    
    func fetchMore() async {
        guard let currentQuery = currentQuery else {
            print("query error - RecentReviewViewModel fetchMore")
            return
        }
        
        ReviewService.getNextRecentReviewsQuery(query: currentQuery) { nextQuery in
            guard let nextQuery = nextQuery else { return }
            self.currentQuery = nextQuery
            Task {
                guard let nextReviews = await ReviewService.convertReviewQueryToReviwVM(query: nextQuery) else {
                    print("decode error - RecentReviewViewModel fetchMore")
                    return
                }
                DispatchQueue.main.async {
                    self.reviews.append(contentsOf: nextReviews)
                }
            }
        }
    }
}
