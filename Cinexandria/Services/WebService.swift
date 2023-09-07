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
            
            let response = try? JSONDecoder().decode(TrendingMovieResponse.self, from: data)
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
            
            let response = try? JSONDecoder().decode(TrendingTvResponse.self, from: data)
            if let response = response {
                completion(.success(response.tvs))
            }
            
        }.resume()
    }
}

