//
//  RecentSearchView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/26.
//

import SwiftUI

struct RecentSearchView: View {
    
    @Binding var searchedText: String
    
    @ObservedObject var searchVM = SearchViewModel.shared
    
    @State private var searchedWords: [String] = LocalData.shared.getSearchedWords()
    
    private func handleDelete(isAll: Bool = false, keyword: String? = nil) {
        if isAll {
            LocalData.shared.deleteSearchedWords(isAll: true)
        } else {
            LocalData.shared.deleteSearchedWords(keyword: keyword)
        }
        self.searchedWords = LocalData.shared.getSearchedWords()
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Text("최근 검색어").customFont(color: .white, size: 18, weight: .heavy)
                Spacer()
                Text("전체삭제").customFont(color: .gray, size: 16, weight: .semibold).onTapGesture {
                    handleDelete(isAll: true)
                }
            }.padding(.top, 20)
            ScrollView(.horizontal) {
                HStack(spacing: 12) {
                    ForEach(searchedWords, id: \.self) { word in
                        Button(action: {
                            Task {
                                await searchVM.fetchSearching(keyword: word)
                            }
                            self.searchedText = word
                        }) {
                            HStack(spacing: 4) {
                                Text(word).customFont(color: .gray, size: 14, weight: .bold)
                                Image(systemName: "xmark").customFont(color: .teal ,size: 12, weight: .semibold).onTapGesture {
                                    handleDelete(keyword: word)
                                }
                            }.padding(10).background(Color("BgPrimary")).cornerRadius(20)
                        }
                    }
                }
            }
        }.onAppear {
            self.searchedWords = LocalData.shared.getSearchedWords()
        }
    }
}
