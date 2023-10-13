//
//  HomeView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                TrendingSection()
                Spacer(minLength: 30)
                ReviewSection()
                Spacer(minLength: 30)
                TopRatedSection()
            }
        }
        .padding()
        .background(.black)
        .navigationTitle(Constants.mainTitle)
        .navigationWrapper()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
