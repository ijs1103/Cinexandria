//
//  LikedWorkViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import Foundation
 
struct LikedWorkViewModel {
    
    let mediaType: MediaType
    let id: Int
    let poster: String
    var posterUrl: URL? {
        return URL(string: poster)
    }
    let title: String
    let rating: String
}
