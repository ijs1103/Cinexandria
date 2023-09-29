//
//  NaverInfoResponse.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/30.
//

import Foundation

struct NaverInfoResponse: Codable {
    let resultcode, message: String
    let response: Response
}

struct Response: Codable {
    let nickname: String
    let profileImage: String
    let id: String

    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImage = "profile_image"
        case id
    }
}
