//
//  Image+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import SwiftUI

extension Image {
    func ImageModifier() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
}
