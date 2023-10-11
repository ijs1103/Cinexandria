//
//  ReviewSection.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/07.
//

import SwiftUI

struct ReviewSection: View {
    
    @ObservedObject private var reviewListVM = ReviewListViewModel()
        
    var body: some View {
        return VStack {
            ListTitleView(title: Constants.SectionTitle.reviews, contents: nil)
            Spacer(minLength: 30)
            ReviewList(reviews: reviewListVM.reviews)
        }.task {
            await reviewListVM.load()
        }
    }
}

struct ReviewSection_Previews: PreviewProvider {
    static var previews: some View {
        ReviewSection()
    }
}
