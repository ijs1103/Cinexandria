//
//  SearchViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    @Published var searchingMovies: [SearchResultViewModel] = []
    @Published var searchingTvs: [SearchResultViewModel] = []
    
    func fetchSearching(keyword: String) async{
        Task {
            do {
                let results = try await Webservice.shared.getSearching(keyword: keyword)
                let movies = results.filter { $0.mediaType == .movie }.map { SearchResultViewModel(work: $0) }
                let tvs = results.filter { $0.mediaType == .tv }.map { SearchResultViewModel(work: $0) }
                DispatchQueue.main.async {
                    self.searchingMovies = movies
                    self.searchingTvs = tvs
                }
            } catch NetworkError.badDecoding {
                print("searching error - badDecoding")
            } catch NetworkError.badServer {
                print("searching error - badServer")
            }
        }
    }
}
