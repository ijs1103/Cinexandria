//
//  Text+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/12.
//

import SwiftUI

extension Text {
    func SubTitleView() -> some View {
        return self.customFont(size: 18, weight: .semibold).foregroundColor(.white).padding(.vertical, 12)
    }
}
