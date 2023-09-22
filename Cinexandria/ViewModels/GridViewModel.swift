//
//  GridViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/21.
//

import SwiftUI

final class GridViewModel: ObservableObject {
    
    @Published var works: [WorkViewModel] = []
    @Published var pageNum: Int = 1
    
    let dataType: DataType
    
    init(dataType: DataType) {
        self.dataType = dataType
    }
    
    func load() async {
        Task {
            do {
                let temp: [WorkViewModel]
                switch dataType {
                case .trendingMovie:
                    temp = try await Webservice.shared.getTrendingMovies().map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                case .trendingTv:
                    temp = try await Webservice.shared.getTrendingTv().map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                case .topRatedMovie:
                    temp = try await Webservice.shared.getTopRatedMovie().map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                case .topRatedTv:
                    temp = try await Webservice.shared.getTopRatedTv().map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                }
                DispatchQueue.main.async {
                    self.works = temp
                }
            } catch NetworkError.badDecoding {
                print("fetch more error - badDecoding")
            } catch NetworkError.badServer {
                print("fetch more error - badServer")
            }
        }
    }
    
    func fetchMore() async {
        pageNum += 1
        
        Task {
            do {
                let temp: [WorkViewModel]
                switch dataType {
                case .trendingMovie:
                    temp = try await Webservice.shared.getTrendingMovies(pageNum: pageNum).map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                case .trendingTv:
                    temp = try await Webservice.shared.getTrendingTv(pageNum: pageNum).map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                case .topRatedMovie:
                    temp = try await Webservice.shared.getTopRatedMovie(pageNum: pageNum).map({ movie in
                        WorkViewModel(movie: movie, mediaType: .movie)
                    })
                case .topRatedTv:
                    temp = try await Webservice.shared.getTopRatedTv(pageNum: pageNum).map({ tv in
                        WorkViewModel(tv: tv, mediaType: .tv)
                    })
                }
                DispatchQueue.main.async {
                    self.works.append(contentsOf: temp)
                }
            } catch NetworkError.badDecoding {
                print("fetch more error - badDecoding")
            } catch NetworkError.badServer {
                print("fetch more error - badServer")
            }
        }
    }
    
}
