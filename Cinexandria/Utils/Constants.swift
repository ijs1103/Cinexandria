//
//  Constants.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import Foundation

struct Constants {
    
    static let kakaoAppKey = "a94940bee0e181ef1c1667613063b505"
    
    static let mainTitle = "🍿 Cinexandria"
    
    static let PAGE_LIMIT = 5
    
    struct Urls {
        
        static private let baseUrl = "https://api.themoviedb.org/3"
        
        static func trending(media: MediaType, pageNum: Int = 1) -> URL? {
            URL(string: "\(baseUrl)/trending/\(media.rawValue)/week?language=ko-KR&page=\(pageNum)")
        }
        
        static func topRated(media: MediaType, pageNum: Int = 1) -> URL? {
            URL(string: "https://api.themoviedb.org/3/\(media.rawValue)/top_rated?language=ko-KR&page=\(pageNum)")
        }
        
        static func detail(media: MediaType, id: Int) -> URL? {
            let appendToRes = (media == .movie) ? "&append_to_response=videos,credits" : ""
            let url = "\(baseUrl)/\(media.rawValue)/\(id)?language=ko-KR\(appendToRes)"
            return URL(string: url)
        }
        
        static func tvCredits(id: Int) -> URL? {
            URL(string: "\(baseUrl)/tv/\(id)/credits?language=ko-KR")
        }
        
        static func tvVideos(id: Int) -> URL? {
            URL(string: "\(baseUrl)/tv/\(id)/videos?language=ko-KR")
        }
        
        static func searchWork(query: String) -> URL? {
            URL(string: "\(baseUrl)/search/multi?language=ko-KR&query=\(query.escaped())")
        }
        
        static func imageBase(width: Int = 200) -> String {
            return "https://image.tmdb.org/t/p/w\(width)"
        }
        
        static func imdbBase(id: String) -> URL? {
            return URL(string: "https://imdb-api.projects.thetuhin.com/title/\(id)") 
        }
        
        static func searching(keyword: String) -> URL? {
            return URL(string: "\(baseUrl)/search/multi?include_adult=false&language=ko-KR&page=1&query=\(keyword.escaped())")
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
        struct search {
            static let movie = "검색영화"
            static let tv = "검색TV"
        }
        static let reviews = "최신 한줄평 ✍️"
    }
    
    struct NavigationTitle {
        static let profileEdit = "프로필 수정"
        static let likedWorks = "찜한 작품"
    }
}
