//
//  Review.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import Foundation

struct Review: Codable {
    let reviewer: String
    let workId: Int
    let workTitle: String
    let title: String
    let rating: String
    let text: String
    let createdAt: String
}
