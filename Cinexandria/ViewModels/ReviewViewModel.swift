//
//  ReviewViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import Foundation

struct ReviewViewModel {

    let review: Review
    
    var id: String {
        return review.id
    }
    
    var uid: String {
        return review.uid
    }
    
    var avatarURL: URL? {
        return URL(string: review.avatarURL)
    }
    
    var posterURL: URL? {
        return URL(string: review.posterURL)
    }
    
    var nickname: String {
        return review.nickname
    }
    
    var workId: Int {
        return review.workId
    }
    
    var mediaType: MediaType {
        return review.mediaType
    }
    
    var workTitle: String {
        return review.workTitle
    }
    
    var title: String {
        return review.title
    }
    
    var rating: Int {
        return review.rating
    }
    
    var text: String {
        return review.text
    }
    
    var createdAt: String {
        return review.createdAt.snsStyleDate()
    }
    
}
