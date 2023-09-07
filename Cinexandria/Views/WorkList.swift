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
        ScrollView(.horizontal) {
            LazyHStack(spacing: 18) {
                ForEach(works, id: \.id) { work in
                    PosterCard(work: work)
                }
            }
        }.frame(maxHeight: 320)
    }
}
