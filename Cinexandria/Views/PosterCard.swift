//
//  PosterCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import SwiftUI

struct PosterCard: View {
    
    @EnvironmentObject private var appState: AppState
    
    let work: WorkViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            AsyncImage(url: work.poster
                       , content: { phase in
                
                if let image = phase.image {
                    image.ImageModifier().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
                } else if phase.error != nil {
                    Image("NoPoster").ImageModifier().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped() // Indicates an error.
                } else {
                    ProgressView() // Acts as a placeholder.
                }
                
            })
            
            VStack(spacing: 0) {
                Text("\(work.title)").font(.system(size: 16, weight: .semibold)).lineLimit(1).foregroundColor(.white).padding(EdgeInsets(top: 4, leading: 10, bottom: 0, trailing: 10))
                HStack {
                    Label {
                        Text("\(work.rating)").customFont(color: .yellow, size: 14, weight: .bold)
                    } icon: {
                        Image(systemName: "star.fill").resizable().frame(width: 14, height: 14)
                    }
                    Spacer()
                }.padding(10).foregroundColor(.yellow)
            }
            .background(Color("BgSecond"))
            .cornerRadius(10, corners: .bottomLeft)
            .cornerRadius(10, corners: .bottomRight)
        }.frame(width: 150).frame(maxHeight: .infinity).redacted(reason: appState.loadingState == .loading ? .placeholder : []).allowsHitTesting(!(appState.loadingState == .loading))
    }
}

