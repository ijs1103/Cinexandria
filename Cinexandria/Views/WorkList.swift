//
//  WorkList.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct WorkList: View {
    
    let works: [WorkViewModel]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            // LazyHStack 버그 : 이미지 크기가 스크롤 하면 변함
            HStack(spacing: 18) {
                ForEach(works, id: \.id) { work in
                    NavigationLink(destination: DetailScreen(media: work.mediaType, id: work.id)) {
                        PosterCard(work: work)
                    }
                }
            }
        }
    }
}
