//
//  LikedPosterCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

struct LikedPosterCard: View {
    
    let likedWork: LikedWorkViewModel

    var body: some View {
        VStack(spacing: 0) {
            
            AsyncImage(url: likedWork.posterUrl
                       , content: { phase in
                
                if let image = phase.image {
                    image.imageFill().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
                } else {
                    Image("NoPoster").imageFill().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
                }
                
            }).frame(width: 160, height: 240)
            
            VStack(spacing: 0) {
                Text("\(likedWork.title)").font(.system(size: 16, weight: .semibold)).lineLimit(1).foregroundColor(.white).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                HStack {
                    Label {
                        Text("\(likedWork.rating)").customFont(color: .yellow, size: 16, weight: .bold)
                    } icon: {
                        Image(systemName: "star.fill").resizable().frame(width: 14, height: 14)
                    }
                    Spacer()
                }.padding(10).foregroundColor(.yellow)
            }
            .frame(width: 160, height: 60)
            .background(Color("BgSecond"))
            .cornerRadius(10, corners: .bottomLeft)
            .cornerRadius(10, corners: .bottomRight)
        }
    }
}
