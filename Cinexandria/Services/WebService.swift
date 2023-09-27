//
//  WebService.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import Foundation

enum NetworkError: Error {
    case badDecoding
    case badURL
    case badServer
    case noData
}

final class Webservice {
    
    static let shared = Webservice()
    private init() {}

    private let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNmZjYjczNTFhMzQyMWE1Yzc0MmExMmIyZWZiOWQzNSIsInN1YiI6IjVmZDQ2ZWE0ZWNjN2U4MDAzZWQyMWE1NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ce2Pa2eE_aV2erPv8KAllyGH50yhdXM_yj0y-CN9c3Y"
    
    private func urlToRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(self.token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    func getTrendingMovies(pageNum: Int = 1) async throws -> [Movie] {
        
        guard let url = Constants.Urls.trending(media: .movie, pageNum: pageNum) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(MovieResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.movies
    }
    
    func getTrendingTv(pageNum: Int = 1) async throws -> [Tv] {
        
        guard let url = Constants.Urls.trending(media: .tv, pageNum: pageNum) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(TvResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.tvs
       
    }
    
    func getTopRatedMovie(pageNum: Int = 1) async throws -> [Movie] {
        
        guard let url = Constants.Urls.topRated(media: .movie, pageNum: pageNum) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(MovieResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.movies
    }
    
    func getTopRatedTv(pageNum: Int = 1) async throws -> [Tv] {
        
        guard let url = Constants.Urls.topRated(media: .tv, pageNum: pageNum) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(TvResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.tvs
    }
    
    func getMovieDetail(id: Int) async throws -> MovieDetailResponse {
        guard let url = Constants.Urls.detail(media: .movie, id: id) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(MovieDetailResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded
    }

    func getTvDetail(id: Int) async throws -> TvDetailResponse {

        guard let url = Constants.Urls.detail(media: .tv, id: id) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(TvDetailResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded
    }
    
    func getTvCredits(id: Int) async throws -> Credits {
        
        guard let url = Constants.Urls.tvCredits(id: id) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(Credits.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded
    }

    func getTvVideos(id: Int) async throws -> String? {
        
        guard let url = Constants.Urls.tvVideos(id: id) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(Videos.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.results.last?.key
    }
    
    func getImdbRating(id: String) async throws -> String {
        
        guard let url = Constants.Urls.imdbBase(id: id) else {
            throw NetworkError.badURL
        }
                
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(ImdbResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return String(decoded.rating.star)
    }
    
    func getSearching(keyword: String) async throws -> [SearchResult] {
        guard let url = Constants.Urls.searching(keyword: keyword) else {
            throw NetworkError.badURL
        }
        
        let request = urlToRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded.results
    }
}

