//
//  SearchResultViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import Foundation

struct SearchResultViewModel {
    
    let work: SearchResult
    
    var mediaType: MediaType {
        return work.mediaType ?? .movie
    }
    
    var id: Int {
        return work.id ?? 0
    }
    
    var title: String {
        return work.title ?? work.name!
    }
    
    var subtitle: String {
        let date = work.releaseDate ?? work.firstAirDate
        return String(date?.split(separator: "-").first ?? "")
    }
    
    var poster: URL? {
        guard let posterPath = work.posterPath else { return nil }
        let baseUrl = "https://image.tmdb.org/t/p/w200"
        return URL(string: "\(baseUrl)\(posterPath)")
    }
}
