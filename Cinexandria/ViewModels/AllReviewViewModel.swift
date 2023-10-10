//
//  AllReviewViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/11.
//

import SwiftUI

final class AllReviewViewModel: ObservableObject {
    
    @Published var reviews: [ReviewViewModel] = []
    
    func fetchReviews(workId: Int) async {
        guard let response = await ReviewService.getReviewsByWork(workId: workId, isAll: true) else {
            return
        }
        let reviews = response.compactMap { ReviewViewModel(review: $0) }
        
        DispatchQueue.main.async {
            self.reviews = reviews
        }
    }
}
