//
//  HomeView.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/05.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Home")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("BgPrimary"))
        .navigationTitle("Cinexandria")
        .navigationWrapper()
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
