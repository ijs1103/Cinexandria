//
//  AvatarView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/01.
//

import SwiftUI

struct AvatarView: View {
    
    let authProfile: AuthProfileViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            AsyncImage(url: authProfile.photoURL
                       , content: { phase in
                if let image = phase.image {
                    image.resizable().scaledToFill()
                } else if phase.error != nil {
                    Image(systemName: "person.fill").resizable().scaledToFill()
                } else {
                    ProgressView()
                }
            }).frame(width: 120, height: 120)
                .clipShape(Circle()).overlay(Circle().stroke(Color("BgThird"), lineWidth: 4))

            Text(authProfile.name).customFont(color: .white, size: 24, weight: .bold)
        }
    }
}
