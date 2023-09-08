//
//  Constants.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import Foundation

struct Constants {
    struct Urls {
        static func trending(media: MediaType) -> URL? {
            URL(string: "https://api.themoviedb.org/3/trending/\(media.rawValue)/week?language=ko-KR")
        }
        
        static func topRated(media: MediaType, pageNum: Int = 1) -> URL? {
            URL(string: "https://api.themoviedb.org/3/\(media.rawValue)/top_rated?language=ko-KR&page=\(pageNum)")
        }
        
        static func detail(media: MediaType, id: String) -> URL? {
            URL(string: "https://api.themoviedb.org/3/\(media.rawValue)/\(id)?language=ko-KR&append_to_response=videos,watch/providers")
        }
        
        static func searchWork(query: String) -> URL? {
            URL(string: "https://api.themoviedb.org/3/search/multi?language=ko-KR&query=\(query.escaped())")
        }
        
    }
    
    struct SectionTitle {
        struct trending {
            static let movie = "요즘 핫한 영화 🔥"
            static let tv = "요즘 핫한 드라마 🔥"
        }
        struct topRated {
            static let movie = "평점 높은 영화 👉"
            static let tv = "평점 높은 드라마 👉"
        }
        static let reviews = "최신 한줄평 ✍️"
    }
}
