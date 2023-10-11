//
//  Review.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import Foundation
import FirebaseFirestore

struct Review {
    let id: String
    let uid: String
    let workId: Int
    let mediaType: MediaType
    let nickname: String
    let photoURL: String
    let rating: Int
    let workTitle: String
    let title: String
    let text: String
    let createdAt: Date
}

extension Review {
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "uid": uid,
            "workId": workId,
            "mediaType": mediaType.rawValue,
            "nickname": nickname,
            "photoURL": photoURL,
            "rating": rating,
            "workTitle": workTitle,
            "title": title,
            "text": text,
            "createdAt": createdAt
        ]
    }
}
