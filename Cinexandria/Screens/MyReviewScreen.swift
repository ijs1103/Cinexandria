//
//  MyReviewScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/12.
//

import SwiftUI

struct MyReviewScreen: View {
    
    @EnvironmentObject private var appState: AppState
    
    let reviews: [ReviewViewModel]
    
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
                if reviews.isEmpty {
                    CustomEmptyView()
                } else {
                    VStack(spacing: 12) {
                        ForEach(reviews, id: \.id) { review in
                            MyReviewCard(review: review)
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
                }
            }.padding(.top, 10)
                .background(.black)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(Constants.NavigationTitle.myReview)
                .tint(.white)
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
