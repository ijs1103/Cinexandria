//
//  ReviewViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import Foundation

struct ReviewViewModel {
    let review: Review
    
    let id = UUID()
    
    var reviewer: String {
        return review.reviewer
    }
    
    var workId: Int {
        return review.workId
    }
    
    var workTitle: String {
        return review.workTitle
    }
    
    var title: String {
        return review.title
    }
    
    var rating: String {
        return review.rating
    }
    
    var text: String {
        return review.text
    }
    
    var createdAt: String {
        return review.createdAt
    }
    
}
