//
//  MyPageViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

final class MyPageViewModel: ObservableObject {
    @Published var likeCount: Int = 0
    @Published var reviewCount: Int = 0
    @Published var myReviews: [ReviewViewModel] = []
    @Published var myContents: [MyPageListCellViewModel] = [MyPageListCellViewModel(title: "작성한 리뷰", count: 0, destination: AnyView(EmptyView())), MyPageListCellViewModel(title: "찜한 작품", count: 0, destination: AnyView(EmptyView()))]
    
    init() {
        Task {
            await fetchReviewAndCount()
            await fetchLikeCount()
            await MainActor.run {
                self.myContents = [MyPageListCellViewModel(title: "작성한 리뷰", count: reviewCount, destination: AnyView(MyReviewScreen(reviews: myReviews))), MyPageListCellViewModel(title: "찜한 작품", count: likeCount, destination: AnyView(LikedWorksScreen()))]
            }
        }
    }
    
    let infoContents: [MyPageListCellViewModel] = [ MyPageListCellViewModel(title: "정보 수정", count: nil, destination: AnyView(ProfileEditScreen())), MyPageListCellViewModel(title: "회원 탈퇴", count: nil, destination: AnyView(WithDrawScreen()))]

    func fetchLikeCount() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - fetchLikeCount")
            return
        }
        let likeCount = await UserService.getLikeCount(uid: uid)
        await MainActor.run {
            self.likeCount = likeCount
        }
    }
    
    func fetchReviewAndCount() async {
        guard let reviewAndCount = await ReviewService.getMyReviewAndCount() else {
            return
        }
        await MainActor.run {
            self.reviewCount = reviewAndCount.count
            self.myReviews = reviewAndCount.reviews
        }
    }
}
