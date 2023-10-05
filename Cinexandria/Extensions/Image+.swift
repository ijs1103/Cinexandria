//
//  Image+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import SwiftUI

extension Image {
    func imageFit() -> some View {
        self
            .resizable()
            .scaledToFit()
    }
    func imageFill() -> some View {
        self
            .resizable()
            .scaledToFill()
    }
}
