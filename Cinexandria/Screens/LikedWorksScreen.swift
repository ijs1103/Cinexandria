//
//  LikedWorksScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/07.
//

import SwiftUI

struct LikedWorksScreen: View {
    
    @EnvironmentObject private var appState: AppState
    
    @ObservedObject var likedWorksVM = LikedWorksViewModel()
    
    @State private var ScrollViewOffset: CGFloat = 0
    
    @State private var StartOffset: CGFloat = 0
    
    private func calcOffset(_ proxy: GeometryProxy) {
        if StartOffset == 0 {
            StartOffset = proxy.frame(in: .global).minY
        }
        let offset = proxy.frame(in: .global).minY
        ScrollViewOffset = offset - StartOffset
    }
    
    var body: some View {
        
        ScrollViewReader { proxyReader in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.fixed(180), spacing: 20), GridItem(.fixed(180), spacing: 20)], spacing: 20) {
                    
                    if likedWorksVM.works.isEmpty {
                        CustomEmptyView()
                    } else {
                        ForEach(likedWorksVM.works, id: \.id) { work in
                            NavigationLink(destination: DetailScreen(media: work.mediaType, id: work.id)) {
                                LikedPosterCard(likedWork: work)
                            }
                        }
                    }
                }.padding().id("ScrollToTop")
                    .overlay(
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                calcOffset(proxy)
                            }
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
            }.padding(.top, 10)
                .background(.black)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Constants.NavigationTitle.likedWorks)
                .tint(.white)
                .loadingWrapper(appState.loadingState).task {
                    appState.loadingState = .loading
                    await likedWorksVM.load()
                    appState.loadingState = .idle
                }
                .overlay(
                    ScrollTopButton(onClick: {
                        withAnimation(.default) {
                            proxyReader.scrollTo("ScrollToTop", anchor: .top)
                        }
                    }).opacity(-ScrollViewOffset > 450 ? 1 : 0)
                    ,alignment: .bottomTrailing
                )
        }
    }
}
