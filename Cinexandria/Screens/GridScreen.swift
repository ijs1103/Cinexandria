//
//  GridScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/20.
//

import SwiftUI

struct GridScreen: View {
    
    @EnvironmentObject private var appState: AppState
    
    let title: String
    
    let dataType: DataType
    
    @ObservedObject var gridVM: GridViewModel
    
    @State private var ScrollViewOffset: CGFloat = 0
    
    @State private var StartOffset: CGFloat = 0
    
    init(title: String, dataType: DataType) {
        self.title = title
        self.dataType = dataType
        self.gridVM = GridViewModel(dataType: self.dataType)
    }
    
    private func shouldFetchMore(id: Int) -> Bool {
        if gridVM.pageNum >= Constants.PAGE_LIMIT { return false }
        return gridVM.works[gridVM.works.endIndex-1].id == id
    }
    
    var body: some View {
        ScrollViewReader { proxyReader in
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: [GridItem(.fixed(180), spacing: 20), GridItem(.fixed(180), spacing: 20)], spacing: 20) {
                    
                    ForEach(gridVM.works, id: \.id) { work in
                        PosterCard(work: work, isBig: true).onAppear(perform: {
                            if shouldFetchMore(id: work.id) {
                                Task {
                                    await gridVM.fetchMore()
                                }
                            }
                        })
                    }
                }.padding().id("ScrollToTop")
                    .overlay(
                        GeometryReader { proxy -> Color in
                            DispatchQueue.main.async {
                                if StartOffset == 0 {
                                    StartOffset = proxy.frame(in: .global).minY
                                }
                                let offset = proxy.frame(in: .global).minY
                                ScrollViewOffset = offset - StartOffset
                            }
                            return Color.clear
                        }
                            .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
            }.padding(.top, 10)
                .background(.black)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle(title)
                .tint(.white)
                .loadingWrapper(appState.loadingState).task {
                    appState.loadingState = .loading
                    await gridVM.load()
                    appState.loadingState = .idle
                }
                .overlay(
                    Button(action: {
                        withAnimation(.default) {
                            proxyReader.scrollTo("ScrollToTop", anchor: .top)
                        }
                    }, label: {
                        Image(systemName: "arrow.up")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("BgThird"))
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    }).padding(.trailing)
                        .padding(.bottom, Theme.getSafeArea().bottom == 0 ? 12 : 0)
                    // 시작점에서 450미만으로 떨어져 있으면 버튼 숨김
                        .opacity(-ScrollViewOffset > 450 ? 1 : 0)
                    ,alignment: .bottomTrailing
                )
        }
    }
}
