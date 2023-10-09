//
//  RatingStar.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

struct RatingStar: View {
    
    @Binding var rating: Int?
    
    private func starColor(index: Int) -> Color {
        if let rating = self.rating {
            return index <= rating ? Color("BgThird") : .gray
        } else {
            return .gray
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("별점").customFont(size: 14, weight: .semibold)
                Spacer()
            }
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill").imageFill().frame(width: 32, height: 32)
                        .foregroundColor(self.starColor(index: index))
                        .onTapGesture {
                            self.rating = index
                    }
                }
            }
        }
    }
}

struct RatingStar_Previews: PreviewProvider {
    static var previews: some View {
        RatingStar(rating: .constant(3))
    }
}
