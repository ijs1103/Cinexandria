//
//  GridScreen.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/20.
//

import SwiftUI

struct GridScreen: View {
    
    let works: [WorkViewModel]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())],spacing: 10) {
                ForEach(works, id: \.id) { work in
                    PosterCard(work: work)
                }
            }
        }.padding(.vertical, 10)
    }
}
