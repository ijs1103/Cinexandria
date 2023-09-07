//
//  TrendingViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import Foundation
import SwiftUI

final class TrendingViewModel: ObservableObject {
    @Published var trendingMovies: [WorkViewModel] = []
    @Published var trendingTvs: [WorkViewModel] = []
    
    func load() {
        fetchTrendingMovies()
        fetchTrendingTv()
    }
    
    private func fetchTrendingMovies() {
        Webservice.shared.getTrendingMovies { result in
            switch result {
            case .success(let movies):
                guard let movies = movies else { return }
                DispatchQueue.main.async {
                    self.trendingMovies = movies.map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTrendingTv() {
        Webservice.shared.getTrendingTv { result in
            switch result {
            case .success(let tvs):
                guard let tvs = tvs else { return }
                DispatchQueue.main.async {
                    self.trendingTvs = tvs.map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
