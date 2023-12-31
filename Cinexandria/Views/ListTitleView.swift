//
//  ListTitleView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

enum DataType {
    case trendingMovie, trendingTv, topRatedMovie, topRatedTv
}

struct ListTitleView: View {
    let title: String
    let contents: Any?
    var dataType: DataType {
        switch self.title {
        case Constants.SectionTitle.trending.movie:
            return .trendingMovie
        case Constants.SectionTitle.trending.tv:
            return .trendingTv
        case Constants.SectionTitle.topRated.movie:
            return .topRatedMovie
        case Constants.SectionTitle.topRated.tv:
            return .topRatedTv
        default:
            return .trendingMovie
        }
    }
    
    private func getDestination(from contents: Any?) -> AnyView {
        if contents is [WorkViewModel] {
            return AnyView(GridScreen(title: title, dataType: dataType))
        } else if contents is [SearchResultViewModel] {
            return AnyView(SearchGridScreen(title: title, works: contents as! [SearchResultViewModel]))
        } else if contents == nil {
            return AnyView(RecentReviewScreen(navigationViewActive: false))
        }
        return AnyView(EmptyView())
    }

    var body: some View {
        HStack {
            Text("\(title)").font(.system(size: 22, weight: .heavy))
            Spacer()
            NavigationLink(destination: getDestination(from: contents)){
                Image(systemName: "chevron.right").tint(Color("FontPrimary"))
            }.disabled((contents as AnyObject).count == 0)
        }
    }
}

