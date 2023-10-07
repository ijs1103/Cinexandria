//
//  VerticalLabelStyle.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/07.
//

import SwiftUI

struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.icon
                .padding(5)
            configuration.title
        }
    }
}
