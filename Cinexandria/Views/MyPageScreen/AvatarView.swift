//
//  AvatarView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/01.
//

import SwiftUI

struct AvatarView: View {
    
    let profile: User?
    
    var url: URL? {
        guard let photoURL = profile?.photoURL else { return nil }
        return URL(string: photoURL)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: url
                       , content: { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else {
                    Image(systemName: "person.fill").resizable().scaledToFill()
                }
            }).frame(width: 120, height: 120)
                .clipShape(Circle()).overlay(Circle().stroke(Color("BgThird"), lineWidth: 4))

            Text(profile?.nickname ?? "unknown").customFont(color: .white, size: 24, weight: .bold)
        }
    }
}
