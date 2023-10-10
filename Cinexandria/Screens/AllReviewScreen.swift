//
//  AllReviewScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/11.
//

import SwiftUI

struct AllReviewScreen: View {
    
    @EnvironmentObject private var appState: AppState
    
    @ObservedObject var allReviewVM = AllReviewViewModel()
    
    @State private var ScrollViewOffset: CGFloat = 0
    
    @State private var StartOffset: CGFloat = 0
    
    let workId: Int
    
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
                    ForEach(allReviewVM.reviews, id: \.id) { review in
                        AllReviewCard(review: review)
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
                .navigationTitle(Constants.NavigationTitle.allReview)
                .tint(.white)
                .loadingWrapper(appState.loadingState).task {
                    appState.loadingState = .loading
                    await allReviewVM.fetchReviews(workId: workId)
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
