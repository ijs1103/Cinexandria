//
//  User.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/02.
//

import Foundation

struct User {
    let nickname: String
    let uid: String
    let photoURL: String
    
    init(dictionary: [String: Any]) {
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.photoURL = dictionary["photoURL"] as? String ?? ""
    }
}
