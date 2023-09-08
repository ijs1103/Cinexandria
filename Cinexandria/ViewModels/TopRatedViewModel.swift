//
//  TopRatedViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import SwiftUI

final class TopRatedViewModel: ObservableObject {
    @Published var movies: [WorkViewModel] = []
    @Published var tvs: [WorkViewModel] = []
    
    func load() {
        fetchTopRatedMovies()
        fetchTopRatedTv()
    }
    
    private func fetchTopRatedMovies() {
        Webservice.shared.getTopRatedMovie { result in
            switch result {
            case .success(let movies):
                guard let movies = movies else { return }
                DispatchQueue.main.async {
                    self.movies = movies.map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchTopRatedTv() {
        Webservice.shared.getTopRatedTv { result in
            switch result {
            case .success(let tvs):
                guard let tvs = tvs else { return }
                DispatchQueue.main.async {
                    self.tvs = tvs.map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
