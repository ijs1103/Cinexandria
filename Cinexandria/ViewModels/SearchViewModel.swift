//
//  SearchViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
    
    static let shared = SearchViewModel()
    private init(){}
    
    @Published var searchingMovies: [SearchResultViewModel] = []
    @Published var searchingTvs: [SearchResultViewModel] = []
    // SearchScreen에서 검색/미검색 시 화면전환을 위한 flag 변수 
    @Published var isSearchDone: Bool = false
    @Published var isResultsEmpty: Bool = false
    
    func fetchSearching(keyword: String) async{
        Task {
            do {
                let results = try await Webservice.shared.getSearching(keyword: keyword)
                self.isResultsEmpty = results.isEmpty
                if isResultsEmpty { return }
                let movies = results.filter { $0.mediaType == .movie }.map { SearchResultViewModel(work: $0) }
                let tvs = results.filter { $0.mediaType == .tv }.map { SearchResultViewModel(work: $0) }
                DispatchQueue.main.async {
                    self.searchingMovies = movies
                    self.searchingTvs = tvs
                    self.isSearchDone = true
                }
            } catch NetworkError.badDecoding {
                print("searching error - badDecoding")
            } catch NetworkError.badServer {
                print("searching error - badServer")
            }
        }
    }
}
