//
//  MyPageViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import SwiftUI

final class MyPageViewModel: ObservableObject {
    @Published var likeCount: Int = 0
    @Published var myContents: [MyPageListCellViewModel] = []
    
    init() {
        Task {
            let likeCount = await fetchLikeCount()
            await MainActor.run {
                self.myContents = [MyPageListCellViewModel(title: "작성한 리뷰", count: 5, destination: AnyView(EmptyView())), MyPageListCellViewModel(title: "찜한 작품", count: likeCount, destination: AnyView(LikedWorksScreen()))]
            }
        }
    }
    
    let infoContents: [MyPageListCellViewModel] = [ MyPageListCellViewModel(title: "정보 수정", count: nil, destination: AnyView(ProfileEditScreen())), MyPageListCellViewModel(title: "회원 탈퇴", count: nil, destination: AnyView(EmptyView()))]

    func fetchLikeCount() async -> Int {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - fetchLikeCount")
            return 0
        }
        let likeCount = await UserService.getLikeCount(uid: uid)
        return likeCount
    }
}
