//
//  HomeScreen.swift
//  SwiftUI-BoilerPlate
//
//  Created by 이주상 on 2023/09/04.
//

import SwiftUI

struct HomeScreen: View {
    var body: some View {
        List {
            ForEach(1...10, id:\.self) { index in
                Text("\(index)")
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Home")
        .navigationWrapper()
    }

}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        return HomeScreen()
    }
}
