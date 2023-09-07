//
//  HomeView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

enum WorkType {
    case movie, tv
}

enum DataType {
    case trending, topRated, reviews
}

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                TrendingSection()
                ReviewSection()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(.black)
        .navigationTitle("Cinexandria")
        .navigationWrapper()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
