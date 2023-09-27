//
//  SearchScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import SwiftUI

struct SearchScreen: View {
    
    @ObservedObject var searchVM = SearchViewModel.shared
    @Environment(\.isSearching) private var isSearching: Bool
    @State var searchedText = ""
    
    private func isKeywordValid(keyword: String) -> Bool {
        return !keyword.isEmpty && keyword.count > 0
    }
    var body: some View {
        ScrollView {
            if searchVM.isSearchDone {
                ListTitleView(title: "\(Constants.SectionTitle.search.movie) \(searchVM.searchingMovies.count)", contents: searchVM.searchingMovies)
                SearchList(works: searchVM.searchingMovies)
                ListTitleView(title: "\(Constants.SectionTitle.search.tv) \(searchVM.searchingTvs.count)", contents: searchVM.searchingTvs)
                SearchList(works: searchVM.searchingTvs)
            } else {
                RecentSearchView(searchedText: $searchedText)
                if searchVM.isResultsEmpty {
                    Text("검색 결과가 없습니다.").customFont(size: 22, weight: .bold).padding(20).frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(.black)
        .searchable(text: $searchedText, placement: .navigationBarDrawer, prompt: "영화/TV 제목 검색")
        .onSubmit(of: .search) {
            if isKeywordValid(keyword: searchedText.trimmed()) {
                Task {
                    await searchVM.fetchSearching(keyword: searchedText)
                }
                LocalData.shared.setSearchedWords(keyword: searchedText)
            }
        }
        // 검색창 cancel 버튼을 눌렀을때 
        .onChange(of: searchedText) { value in
            if searchedText.isEmpty && !isSearching {
                searchVM.isSearchDone = false
            }
        }
        .navigationWrapper()
    }
}

struct SearchScreen_Previews: PreviewProvider {
    static var previews: some View {
        SearchScreen()
    }
}
