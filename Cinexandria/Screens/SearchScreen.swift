//
//  SearchScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import SwiftUI

struct SearchScreen: View {
    
    @ObservedObject var searchVM = SearchViewModel()
    @State var searchedText = ""
    
    private func isKeywordValid(keyword: String) -> Bool {
        return !keyword.trimmed().isEmpty && keyword.trimmed().count > 0
    }
    
    var body: some View {
        ScrollView {
            if !searchedText.isEmpty {
                ListTitleView(title: "\(Constants.SectionTitle.search.movie) \(searchVM.searchingMovies.count)", contents: searchVM.searchingMovies)
                SearchList(works: searchVM.searchingMovies)
                ListTitleView(title: "\(Constants.SectionTitle.search.tv) \(searchVM.searchingTvs.count)", contents: searchVM.searchingTvs)
                SearchList(works: searchVM.searchingTvs)
            } 
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
        .searchable(text: $searchedText, placement: .navigationBarDrawer, prompt: "영화/TV 제목 검색")
        .onSubmit(of: .search) {
            if isKeywordValid(keyword: searchedText) {
                Task {
                    await searchVM.fetchSearching(keyword: searchedText)
                }
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
