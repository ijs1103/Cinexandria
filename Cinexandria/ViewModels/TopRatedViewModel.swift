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
    
    func load() async {
        await fetchTopRatedMovies()
        await fetchTopRatedTv()
    }
    
    private func fetchTopRatedMovies() async {
        Task {
            do {
                let movies = try await Webservice.shared.getTopRatedMovie().map({ movie in
                    WorkViewModel(movie: movie, mediaType: .movie)
                })
                DispatchQueue.main.async {
                    self.movies = movies
                }
            } catch NetworkError.badDecoding {
                print("topRated movie error - badDecoding")
            } catch NetworkError.badServer {
                print("topRated movie error - badServer")
            }
        }
    }
    
    private func fetchTopRatedTv() async {
        Task {
            do {
                let tvs = try await Webservice.shared.getTopRatedTv().map({ tv in
                    WorkViewModel(tv: tv, mediaType: .tv)
                })
                DispatchQueue.main.async {
                    self.tvs = tvs
                }
            } catch NetworkError.badDecoding {
                print("topRated tv error - badDecoding")
            } catch NetworkError.badServer {
                print("topRated tv error - badServer")
            }
        }
    }
}
