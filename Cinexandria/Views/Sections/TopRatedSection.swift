//
//  TopRatedSection.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import SwiftUI

struct TopRatedSection: View {
    @ObservedObject private var topRatedVM = TopRatedViewModel()

    var body: some View {
        VStack<TupleView<(ListTitleView, WorkList, Spacer, ListTitleView, WorkList)>> {
            ListTitleView(title: Constants.SectionTitle.topRated.movie, contents: self.topRatedVM.movies)
            WorkList(works: self.topRatedVM.movies)
            Spacer(minLength: 30)
            ListTitleView(title: Constants.SectionTitle.topRated.tv, contents: self.topRatedVM.tvs)
            WorkList(works: self.topRatedVM.tvs)
        }.task {
            await topRatedVM.load()
        }
    }
}
