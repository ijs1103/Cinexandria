//
//  LikedWorksViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/07.
//

import SwiftUI

final class LikedWorksViewModel: ObservableObject {
    
    @Published var works: [LikedWorkViewModel] = []
    
    func load() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - LikedWorksViewModel.load()")
            return
        }
        guard let likedWorks = await UserService.getLikedWorks(uid: uid) else {
            return
        }
        DispatchQueue.main.async {
            self.works = likedWorks.compactMap({ work in
                self.decodeSnapshot(dict: work)
            })
            
        }
    }
    
    private func decodeSnapshot(dict: [String: Any]) -> LikedWorkViewModel? {
        
        guard let id = dict["id"] as? Int,
              let mediaType = MediaType(rawValue: (dict["mediaType"] as! String)),
              let poster = dict["poster"] as? String,
              let title = dict["title"] as? String,
              let rating = dict["rating"] as? String else { return nil }
        
        return LikedWorkViewModel(mediaType: mediaType, id: id, poster: poster, title: title, rating: rating)
    }
}
