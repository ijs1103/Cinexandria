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
    
    @AppStorage("searchedWords")
    var searchedWords: Data = Data()
    
    func getSearchedWords() -> [String] {
        print("get 실행")
        guard let decoded = try? JSONDecoder().decode([String].self, from: searchedWords) else {
            return []
        }
        return decoded
    }
    
    func setSearchedWords(keyword: String) {
        print("set 실행")
        var searchedWords = getSearchedWords()
        if searchedWords.contains(keyword) { return }
        searchedWords.append(keyword)
        guard let encoded = try? JSONEncoder().encode(searchedWords) else { return }
        self.searchedWords = encoded
    }
    
    func deleteSearchedWords(keyword: String? = nil, isAll: Bool = false) {
        print("삭제 실행")
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

extension Data {
    func decode() -> [String] {
        guard let decoded = try? JSONDecoder().decode([String].self, from: self) else {
            return []
        }
        return decoded
    }
}
