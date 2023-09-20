//
//  ListTitleView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct ListTitleView: View {
    let title: String
    let contents: Any
    private func getDestination(from contents: Any) -> AnyView {
        if contents is [WorkViewModel] {
            return AnyView(GridScreen(works: contents as! [WorkViewModel]))
        }
        return AnyView(EmptyView())
    }

    var body: some View {
        HStack {
            Text("\(title)").font(.system(size: 22, weight: .heavy))
            Spacer()
            NavigationLink(destination: getDestination(from: contents)){
                Image(systemName: "chevron.right").tint(Color("FontPrimary"))
            }
        }
    }
}

