//
//  WorkViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/06.
//

import Foundation

struct WorkViewModel {
        
    let movie: Movie?
    
    let tv: Tv?
    
    let mediaType: MediaType
    
    init(movie: Movie? = nil, tv: Tv? = nil, mediaType: MediaType) {
        self.movie = movie
        self.tv = tv
        self.mediaType = mediaType
    }
    
    var id: Int {
        return movie?.id ?? tv!.id
    }
    
    var poster: URL? {
        guard let posterPath = (mediaType == .movie) ? movie?.posterPath : tv?.posterPath else { return nil }
        let urlString = "https://image.tmdb.org/t/p/w200\(posterPath)"
        return URL(string: urlString)
    }
    
    var title: String {
        return movie?.title ?? tv!.name
    }
    
    var rating: String {
        return (mediaType == .movie) ? "\(round(movie!.voteAverage * 10))%" : "\(round(tv!.voteAverage * 10))%"
    }
}
