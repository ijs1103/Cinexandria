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
    case person = "person"
}

// MARK: - MovieDetailResponse
struct MovieDetailResponse: Codable {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: BelongsToCollection?
    let budget: Int
    let genres: [Genre]
    let homepage: String
    let id: Int
    let imdbID: String?
    let originalLanguage, originalTitle, overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]
    let releaseDate: String
    let revenue, runtime: Int
    let spokenLanguages: [SpokenLanguage]
    let status, tagline, title: String
    let video: Bool
    let voteAverage: DoubleOrInt
    let voteCount: Int
    let videos: Videos?
    let credits: Credits?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case videos, credits
    }
}

// MARK: - BelongsToCollection
struct BelongsToCollection: Codable {
    let id: Int
    let name: String
    let posterPath, backdropPath: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
    }
}

// MARK: - Credits
struct Credits: Codable {
    let cast, crew: [Cast]
    let id: Int?
}

// MARK: - Cast
struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment, name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: String?
    let job: String?

    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}


// MARK: - Genre
struct Genre: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

// MARK: - SpokenLanguage
struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

// MARK: - Videos
struct Videos: Codable {
    let results: [VideoResult]
    let id: Int?
}

// MARK: - Result
struct VideoResult: Codable {
    let iso639_1, iso3166_1, name, key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt, id: String

    enum CodingKeys: String, CodingKey {
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case name, key, site, size, type, official
        case publishedAt = "published_at"
        case id
    }
}

// MARK: - ImdbResponse
struct ImdbResponse: Codable {
    let id, reviewAPIPath: String
    let imdb: String
    let contentType, productionStatus, title: String
    let image: String
    let images: [String]
    let plot: String
    let rating: Rating
    let award: Award
    let contentRating: String?
    let genre: [String]
    let releaseDetailed: ReleaseDetailed
    let year: Int
    let spokenLanguages: [Language]
    let filmingLocations: [String]
    let runtime: String
    let runtimeSeconds: Int
    let actors, directors: [String]
    let topCredits: [TopCredit]

    enum CodingKeys: String, CodingKey {
        case id
        case reviewAPIPath = "review_api_path"
        case imdb, contentType, productionStatus, title, image, images, plot, rating, award, contentRating, genre, releaseDetailed, year, spokenLanguages, filmingLocations, runtime, runtimeSeconds, actors, directors
        case topCredits = "top_credits"
    }
}

// MARK: - Award
struct Award: Codable {
    let wins, nominations: Int
}

// MARK: - Rating
struct Rating: Codable {
    let count: Int
    let star: Double
}

// MARK: - ReleaseDetailed
struct ReleaseDetailed: Codable {
    let day, month, year: Int
    let releaseLocation: Location
    let originLocations: [Location]
}

// MARK: - Location
struct Location: Codable {
    let country, cca2: String
}

// MARK: - SpokenLanguage
struct Language: Codable {
    let language, id: String
}

// MARK: - TopCredit
struct TopCredit: Codable {
    let name: String
    let value: [String]
}
