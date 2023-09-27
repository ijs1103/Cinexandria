//
//  WorkDetailViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import Foundation

struct WorkDetailViewModel {
    
    mutating func setTvCredits(credits: Credits) {
        tvActors = credits.cast.map { person in
            CreditViewModel(id: person.creditID, name: person.name, role: person.character ?? "", url: person.profilePath != nil ? URL(string: "\(Constants.Urls.imageBase())\(person.profilePath!)") : nil)
        }
        tvStaffs = credits.crew.map { person in
            CreditViewModel(id: person.creditID, name: person.name, role: person.job ?? "", url: person.profilePath != nil ? URL(string: "\(Constants.Urls.imageBase())\(person.profilePath!)") : nil)
        }
    }
    
    let movie: MovieDetailResponse?
    
    let tv: TvDetailResponse?
    
    let media: MediaType
    
    init(movie: MovieDetailResponse? = nil, tv: TvDetailResponse? = nil, media: MediaType) {
        self.movie = movie
        self.tv = tv
        self.media = media
    }
    
    var id: Int {
        return movie?.id ?? tv!.id ?? 0
    }
    
    var poster: URL? {
        return (media == .movie) ? URL(string: "\(Constants.Urls.imageBase())\(movie!.posterPath)") : URL(string: "\(Constants.Urls.imageBase())\(tv!.posterPath)")
    }
    
    var backdrop: URL? {
        return (media == .movie) ? URL(string: "\(Constants.Urls.imageBase(width: 500))\(movie!.backdropPath)") : URL(string: "\(Constants.Urls.imageBase(width: 500))\(tv!.backdropPath)")
    }
    
    var title: String {
        return movie?.title ?? tv!.name
    }
    
    var originalTitle: String {
        return movie?.originalTitle ?? tv!.originalName
    }
    
    var overview: String {
        return movie?.overview ?? tv!.overview
    }
    
    var isLiked: Bool {
        return false
    }
    
    var releaseYear: String {
        if let movieDate = movie?.releaseDate {
            return String(movieDate.split(separator: "-").first ?? "")
        }
        if let tvDate = tv?.firstAirDate {
            return String(tvDate.split(separator: "-").first ?? "")
        }
        return ""
    }
    
    var rating: String {
        if media == .movie {
            switch movie!.voteAverage.self {
            case .double(let voteAverage):
                return "\(round((voteAverage * 10)))%"
            case .int(let voteAverage):
                return "\((voteAverage * 10))%"
            }
        } else {
            switch tv!.voteAverage.self {
            case .double(let voteAverage):
                return "\(round((voteAverage * 10)))%"
            case .int(let voteAverage):
                return "\((voteAverage * 10))%"
            }
        }
        
        
    }
    
    var hashTagItems: [String]? {
        if media == .movie {
            let tmp = movie?.genres.map { genre in
                "#\(genre.name)"
            }
            guard var wrappedTmp = tmp else { return nil }
            guard let runtime = movie?.runtime, let releaseDate = movie?.releaseDate else { return nil }
            [ "#\(runtime)분", "#\(releaseDate)" ].forEach { wrappedTmp.append($0) }
            return wrappedTmp
        } else {
            let tmp = tv?.genres?.map { genre in
                "#\(genre.name)"
            }
            guard var wrappedTmp = tmp else { return nil }
            guard let episodeCnt = tv?.numberOfEpisodes, let seasonCnt = tv?.numberOfSeasons, let releaseDate = tv?.firstAirDate else { return nil }
            [ "#총 \(episodeCnt)화", "#총 \(seasonCnt)시즌", "#\(releaseDate)" ].forEach { wrappedTmp.append($0) }
            return wrappedTmp
        }
    }
    
    var movieActors: [CreditViewModel]? {
        if let movieCast = movie?.credits?.cast {
            return movieCast.map { person in
                CreditViewModel(id: person.creditID, name: person.name, role: person.character ?? "", url: person.profilePath != nil ? URL(string: "\(Constants.Urls.imageBase())\(person.profilePath!)") : nil)
            }
        }
        return nil
    }
    
    var tvActors: [CreditViewModel]?
    
    var movieStaffs: [CreditViewModel]? {
        if let movieCrew = movie?.credits?.crew {
            return movieCrew.map { person in
                CreditViewModel(id: person.creditID, name: person.name, role: person.job ?? "", url: person.profilePath != nil ? URL(string: "\(Constants.Urls.imageBase())\(person.profilePath!)") : nil)
            }
        }
        return nil
    }
    
    var tvStaffs: [CreditViewModel]?
}
