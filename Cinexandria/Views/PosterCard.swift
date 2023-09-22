//
//  PosterCard.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import SwiftUI

struct PosterCard: View {
    
    let work: WorkViewModel
    
    let isBig: Bool
    
    init(work: WorkViewModel, isBig: Bool = false) {
        self.work = work
        self.isBig = isBig
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            AsyncImage(url: work.poster
                       , content: { phase in
                
                if let image = phase.image {
                    image.resizable().scaledToFill().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
                } else if phase.error != nil {
                    Image("NoPoster").scaledToFill().cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped() // Indicates an error.
                } else {
                    ProgressView() // Acts as a placeholder.
                }
                
            }).frame(width: isBig ? 180 : 140, height: isBig ? 270 : 210)
            
            VStack(spacing: 0) {
                Text("\(work.title)").font(.system(size: 14, weight: .semibold)).lineLimit(1).foregroundColor(.white).padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 10))
                HStack {
                    Label {
                        Text("\(work.rating)").customFont(color: .yellow, size: 14, weight: .bold)
                    } icon: {
                        Image(systemName: "star.fill").resizable().frame(width: 14, height: 14)
                    }
                    Spacer()
                }.padding(10).foregroundColor(.yellow)
            }
            .frame(width: isBig ? 180 : 140, height: isBig ? 60 : 50)
            .background(Color("BgSecond"))
            .cornerRadius(10, corners: .bottomLeft)
            .cornerRadius(10, corners: .bottomRight)
        }
    }
}

