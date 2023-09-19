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
    
    func load() async {
        await fetchTrendingMovies()
        await fetchTrendingTv()
    }
    
    private func fetchTrendingMovies() async {
        Task {
            do {
                let trendingMovies = try await Webservice.shared.getTrendingMovies().map({ movie in
                    WorkViewModel(movie: movie, mediaType: .movie)
                })
                DispatchQueue.main.async {
                    self.trendingMovies = trendingMovies
                }
            } catch NetworkError.badDecoding {
                print("trending movie error - badDecoding")
            } catch NetworkError.badServer {
                print("trending movie error - badServer")
            }
        }
    }
    
    private func fetchTrendingTv() async {
        Task {
            do {
                let trendingTvs = try await Webservice.shared.getTrendingTv().map({ tv in
                    WorkViewModel(tv: tv, mediaType: .tv)
                })
                DispatchQueue.main.async {
                    self.trendingTvs = trendingTvs
                }
            } catch NetworkError.badDecoding {
                print("trending tv error - badDecoding")
            } catch NetworkError.badServer {
                print("trending tv error - badServer")
            }
        }
    }
}
