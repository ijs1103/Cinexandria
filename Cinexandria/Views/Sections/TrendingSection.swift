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
            ListTitleView(title: Constants.SectionTitle.trending.movie, contents: self.trendingVM.trendingMovies)
            WorkList(works: self.trendingVM.trendingMovies)
            Spacer(minLength: 30)
            ListTitleView(title: Constants.SectionTitle.trending.tv, contents: self.trendingVM.trendingTvs)
            WorkList(works: self.trendingVM.trendingTvs)
        }.loadingWrapper(appState.loadingState).task {
            appState.loadingState = .loading
            await trendingVM.load()
            appState.loadingState = .idle
        }
    }
}

struct TrendingSection_Previews: PreviewProvider {
    static var previews: some View {
        TrendingSection()
    }
}
