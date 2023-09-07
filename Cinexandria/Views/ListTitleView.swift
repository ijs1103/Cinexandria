//
//  ListTitleView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct ListTitleView: View {
    let title: String
    var body: some View {
        HStack {
            Text("\(title)").font(.system(size: 18, weight: .heavy))
            Spacer()
            Image(systemName: "chevron.right").tint(Color("FontPrimary"))
        }
        
    }
}

struct ListTitleView_Previews: PreviewProvider {
    static var previews: some View {
        ListTitleView(title: Constants.SectionTitle.trending.movie)
    }
}
