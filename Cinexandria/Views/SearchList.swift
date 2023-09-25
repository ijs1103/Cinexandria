//
//  SearchList.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/23.
//

import SwiftUI

struct SearchList: View {
    
    let works: [SearchResultViewModel]
    
    let rows = [
        GridItem(.fixed(90), spacing: 8),
        GridItem(.fixed(90), spacing: 8),
        GridItem(.fixed(90), spacing: 8)
    ]
 
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 0) {
                ForEach(works, id: \.id) { work in
                    NavigationLink(destination: DetailScreen(media: work.mediaType, id: work.id)) {
                        // Grid의 다음 section이 살짝 보이게 하기 위해 너비를 조정.
                        SearchResultCard(work: work).frame(width: UIScreen.main.bounds.size.width - 60)
                    }
                }
            }
        }
    }
}

