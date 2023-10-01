//
//  MyPageListCell.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/01.
//

import SwiftUI

struct MyPageListCell: View {
    
    let content: MyPageListCellViewModel
    
    var body: some View {
        HStack {
            Text(content.title).customFont(size: 16, weight: .bold)
            Spacer()
            HStack {
                if let count = content.count {
                    Text(count).customFont(size: 16, weight: .bold)
                }
                Image(systemName: "chevron.forward").customFont(color: .gray, size: 12, weight: .semibold)
            }
        }
    }
}
