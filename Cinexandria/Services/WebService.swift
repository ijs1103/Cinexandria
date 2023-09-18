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
    
    let token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNmZjYjczNTFhMzQyMWE1Yzc0MmExMmIyZWZiOWQzNSIsInN1YiI6IjVmZDQ2ZWE0ZWNjN2U4MDAzZWQyMWE1NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Ce2Pa2eE_aV2erPv8KAllyGH50yhdXM_yj0y-CN9c3Y"
    
    func getTrendingMovies(completion: @escaping ((Result<[Movie]?, NetworkError>) -> Void)) {
        guard let url = Constants.Urls.trending(media: .movie) else {
            return completion(.failure(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(MovieResponse.self, from: data)
            if let response = response {
                completion(.success(response.movies))
            }
            
        }.resume()
    }
    
    func getTrendingTv(completion: @escaping ((Result<[Tv]?, NetworkError>) -> Void)) {
        guard let url = Constants.Urls.trending(media: .tv) else {
            return completion(.failure(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(TvResponse.self, from: data)
            if let response = response {
                completion(.success(response.tvs))
            }
            
        }.resume()
    }
    
    func getTopRatedMovie(completion: @escaping ((Result<[Movie]?, NetworkError>) -> Void)) {
        guard let url = Constants.Urls.topRated(media: .movie) else {
            return completion(.failure(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(MovieResponse.self, from: data)
            if let response = response {
                completion(.success(response.movies))
            }
            
        }.resume()
    }
    
    func getTopRatedTv(completion: @escaping ((Result<[Tv]?, NetworkError>) -> Void)) {
        guard let url = Constants.Urls.topRated(media: .tv) else {
            return completion(.failure(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(TvResponse.self, from: data)
            if let response = response {
                completion(.success(response.tvs))
            }
            
        }.resume()
    }
    
    func getMovieDetail(id: Int, completion: @escaping ((Result<MovieDetailResponse?, NetworkError>) -> Void)) {
        
        guard let url = Constants.Urls.detail(media: .movie, id: id) else {
            return completion(.failure(.badURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }

            let response = try? JSONDecoder().decode(MovieDetailResponse.self, from: data)
            
            if let response = response {
                completion(.success(response))
            }
            
        }.resume()
    }

    func getTvDetail(id: Int) async throws -> TvDetailResponse {

        guard let url = Constants.Urls.detail(media: .tv, id: id) else {
            throw NetworkError.badURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badServer
        }
        guard let decoded = try? JSONDecoder().decode(Credits.self, from: data) else {
            throw NetworkError.badDecoding
        }
        
        return decoded
    }

    func getTvVideos(id: Int, completion: @escaping ((Result<String?, NetworkError>) -> Void)) {
        
        guard let url = Constants.Urls.tvVideos(id: id) else {
            return completion(.failure(.badURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            let response = try? JSONDecoder().decode(Videos.self, from: data)
            
            if let response = response {
                completion(.success(response.results.last?.key))
            }
            
        }.resume()
    }
    
    func getImdbRating(id: String, completion: @escaping ((Result<String?, NetworkError>) -> Void)) {
        guard let url = Constants.Urls.imdbBase(id: id) else {
            return completion(.failure(.badURL))
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else {
                return completion(.failure(.noData))
            }
            
            let response = try? JSONDecoder().decode(ImdbResponse.self, from: data)
            if let response = response {
                completion(.success(String(response.rating.star)))
            }
            
        }.resume()
    }
}

