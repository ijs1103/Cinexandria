//
//  TV.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import Foundation

struct TvResponse: Codable {
    let page: Int
    let tvs: [Tv]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case tvs = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct Tv: Codable {
    let adult: Bool? = nil
    let backdropPath: String
    let id: Int
    let name: String
    let originalLanguage: String
    let originalName, overview, posterPath: String
    let mediaType: MediaType? = nil
    let genreIDS: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id, name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case genreIDS = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}

