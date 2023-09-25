//
//  SearchResultCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/24.
//

import SwiftUI

struct SearchResultCard: View {
    
    let work: SearchResultViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: work.poster
                       , content: { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill().cornerRadius(8)
                } else if phase.error != nil {
                    Image("NoPoster").resizable().scaledToFill().cornerRadius(8)
                } else {
                    ProgressView()
                }
            }).frame(width: 60, height: 90)
            VStack(alignment: .leading, spacing: 8) {
                Text(work.title).customFont(color: .white, size: 16, weight: .bold)
                Text(work.subtitle).customFont(color: .gray, size: 14, weight: .semibold)
            }.padding(.top, 12)
            Spacer()
        }
    }
}

