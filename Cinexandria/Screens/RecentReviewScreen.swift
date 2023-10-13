//
//  RecentReviewScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/11.
//

import SwiftUI

struct RecentReviewScreen: View {
    @EnvironmentObject private var appState: AppState
    
    @ObservedObject var recentReviewVM = RecentReviewViewModel()
    
    @State private var ScrollViewOffset: CGFloat = 0
    
    @State private var StartOffset: CGFloat = 0
    
    // NavigtionLink를 통해 현재 화면으로 이동해올때 navigationview를 toggle 하기 위한 flag 변수
    // NavigtionLink를 통해 현재 화면으로 이동해오면 navigationview을 off 해야한다. 그렇지 않으면 navigationTitle이 한블럭 아래에 위치하게 된다.
    let navigationViewActive: Bool
    
    init(navigationViewActive: Bool = true) {
        self.navigationViewActive = navigationViewActive
    }
        
    private func shouldFetchMore(id: String) -> Bool {
        return recentReviewVM.reviews[recentReviewVM.reviews.endIndex-1].id == id
    }
    
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
                VStack(spacing: 12) {
                    ForEach(recentReviewVM.reviews, id: \.id) { review in
                        NavigationLink(destination: ReviewDetailScreen(review: review)) {
                            AllReviewCard(review: review)
                        }.onAppear(perform: {
                            if shouldFetchMore(id: review.id) {
                                Task {
                                    await recentReviewVM.fetchMore()
                                }
                            }
                        })
                    }
                }
                .padding().id("ScrollToTop")
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
                .navigationTitle(Constants.NavigationTitle.recentReview)
                .if(navigationViewActive) { view in
                    view.navigationWrapper()
                }
                .tint(.white)
                .loadingWrapper(appState.loadingState).task {
                    appState.loadingState = .loading
                    await recentReviewVM.load()
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
