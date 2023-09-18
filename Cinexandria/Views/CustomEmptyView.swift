//
//  CustomEmptyView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/15.
//

import SwiftUI

struct CustomEmptyView: View {
    
    var body: some View {
        Text("등록된 정보가 없습니다.").customFont(color: Color("BgSecond"), size: 20, weight: .semibold).padding(20)
            .frame(maxWidth: .infinity)
    }
}

