//
//  TopRatedSection.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/08.
//

import SwiftUI

struct TopRatedSection: View {
    @ObservedObject private var topRatedVM = TopRatedViewModel()
    
    init() {
        topRatedVM.load()
    }
    
    var body: some View {
        return VStack<TupleView<(ListTitleView, WorkList, Spacer, ListTitleView, WorkList)>> {
            ListTitleView(title: Constants.SectionTitle.topRated.movie)
            WorkList(works: self.topRatedVM.movies)
            Spacer(minLength: 30)
            ListTitleView(title: Constants.SectionTitle.topRated.tv)
            WorkList(works: self.topRatedVM.tvs)
        }
    }
}

struct TopRatedSection_Previews: PreviewProvider {
    static var previews: some View {
        TopRatedSection()
    }
}
