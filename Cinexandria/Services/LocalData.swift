//
//  LocalData.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/26.
//

import SwiftUI

final class LocalData {
    
    static let shared = LocalData()
    private init(){}
    
    @AppStorage("userId")
    var userId: String?
    
    @AppStorage("searchedWords")
    var searchedWords: Data = Data()
    
    func getSearchedWords() -> [String] {
        guard let decoded = try? JSONDecoder().decode([String].self, from: searchedWords) else {
            return []
        }
        return decoded
    }
    
    func setSearchedWords(keyword: String) {
        var searchedWords = getSearchedWords()
        if searchedWords.contains(keyword) { return }
        searchedWords.append(keyword)
        guard let encoded = try? JSONEncoder().encode(searchedWords) else { return }
        self.searchedWords = encoded
    }
    
    func deleteSearchedWords(keyword: String? = nil, isAll: Bool = false) {
        let searchedWords = getSearchedWords()
        if searchedWords.isEmpty { return }
        if isAll {
            self.searchedWords = Data()
        } else {
            let newSearchedWords = searchedWords.filter({ $0 != keyword })
            guard let encoded = try? JSONEncoder().encode(newSearchedWords) else { return }
            self.searchedWords = encoded
        }
    }
}
