//
//  Movie.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/06.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int
    let movies: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case movies = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let adult: Bool
    let backdropPath: String
    let id: Int
    let title: String
    let originalLanguage: String
    let originalTitle, overview, posterPath: String
    let mediaType: MediaType? = nil
    let genreIDS: [Int]
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case id, title, adult, overview, popularity, video
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

