//
//  HomeScreen.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Label("홈", systemImage: "house.fill")
            }
            EmptyView().tabItem {
                Label("검색", systemImage: "magnifyingglass")
            }
            EmptyView().tabItem {
                Label("한줄평", systemImage: "bubble.left.fill")
            }
            EmptyView().tabItem {
                Label("마이페이지", systemImage: "person.fill")
            }
        }.accentColor(.white)
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        return HomeScreen()
    }
}
