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
            
            if let poster = work.poster {
                KfManager.downSampledImage(url: poster, size: CGSize(width: isBig ? 180 : 120, height: isBig ? 270 : 180)).placeholder {
                    ProgressView()
                }.imageFill().frame(width: isBig ? 180 : 120, height: isBig ? 270 : 180).cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
            } else {
                Image("NoPoster").imageFill().frame(width: isBig ? 180 : 120, height: isBig ? 270 : 180).cornerRadius(10, corners: .topLeft).cornerRadius(10, corners: .topRight).clipped()
            }
            
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
            .frame(width: isBig ? 180 : 120, height: isBig ? 60 : 50)
            .background(Color("BgPrimary"))
            .cornerRadius(10, corners: .bottomLeft)
            .cornerRadius(10, corners: .bottomRight)
            .shadowedStyle()
        }
    }
}

