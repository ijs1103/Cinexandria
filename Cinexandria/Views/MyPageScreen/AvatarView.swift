//
//  AvatarView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/01.
//

import SwiftUI

struct AvatarView: View {
    
    let isEditing: Bool
    
    let previewImage: UIImage?
    
    let profile: User?
    
    var url: URL? {
        guard let photoURL = profile?.photoURL else { return nil }
        return URL(string: photoURL)
    }
    
    init(profile: User?, isEditing: Bool = false, previewImage: UIImage? = nil) {
        self.profile = profile
        self.isEditing = isEditing
        self.previewImage = previewImage
    }
    
    var body: some View {
        VStack(spacing: 16) {
            if let previewImage = previewImage {
                Image(uiImage: previewImage).imageFill().imageModifier(isEditing: isEditing)
            } else {
                AsyncImage(url: url
                           , content: { phase in
                    if let image = phase.image {
                        image.imageFill().imageModifier(isEditing: isEditing)
                    } else {
                        Image(systemName: "person.fill").imageFill().imageModifier(isEditing: isEditing)
                    }
                })
            }
            
            if !isEditing {
                Text(profile?.nickname ?? "unknown").customFont(color: .white, size: 24, weight: .bold)
            }
        }
    }
}

extension View {
    func imageModifier(isEditing: Bool) -> some View {
        self.frame(width: 120, height: 120)
            .if(isEditing) { view in
                view.overlay(alignment: .bottom) {
                    ZStack(alignment: .top) {
                        Rectangle().fill(Color("BgDarkGray").opacity(0.9)).frame(width: 120, height: 45)
                        Text("변경").customFont(color: .white, size: 16, weight: .bold).padding(.top, 6)
                    }
                }
            }
            .clipShape(Circle()).overlay(Circle().stroke(Color("BgThird"), lineWidth: 4))
    }
}
