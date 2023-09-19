//
//  TrendingSection.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct TrendingSection: View {
    
    @EnvironmentObject private var appState: AppState
    
    @ObservedObject var trendingVM = TrendingViewModel()
    
    var body: some View {
        return VStack<TupleView<(ListTitleView, WorkList, Spacer, ListTitleView, WorkList)>> {
            ListTitleView(title: Constants.SectionTitle.trending.movie)
            WorkList(works: self.trendingVM.trendingMovies)
            Spacer(minLength: 30)
            ListTitleView(title: Constants.SectionTitle.trending.tv)
            WorkList(works: self.trendingVM.trendingTvs)
        }.task {
            appState.loadingState = .loading
            trendingVM.load() // <- 이거 async/await으로 바꾸기
            appState.loadingState = .idle
        }
    }
}

struct TrendingSection_Previews: PreviewProvider {
    static var previews: some View {
        TrendingSection()
    }
}
