//
//  AppState.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/19.
//

import Foundation

enum LoadingState: Hashable, Identifiable {
    
    case idle, loading
    
    var id: Self {
        return self
    }
}

struct ErrorWrapper: Identifiable {
    let id = UUID()
    let error: Error
    var guidance: String = ""
}

enum Route: Hashable {
    case main
    case login
    case signup
}

class AppState: ObservableObject {
    @Published var loadingState: LoadingState = .idle
    @Published var errorWrapper: ErrorWrapper?
    @Published var routes: [Route] = []
}
