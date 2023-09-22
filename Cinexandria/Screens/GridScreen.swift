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
        ScrollView {

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
            }.padding()
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
    }
}
