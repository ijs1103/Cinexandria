//
//  ProfileEditViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/05.
//

import SwiftUI
import FirebaseStorage

final class ProfileEditViewModel: ObservableObject {
    @Published var trendingMovies: [WorkViewModel] = []
    
    func updateProfile(data: [String: Any]) {
        guard let uid = LocalData.shared.userId else { return }
        Task {
            await UserService.updateUser(uid: uid, data: data)
        }
    }
    
    func uploadImageAndGetURL(data: Data) async -> URL? {
        guard let uid = LocalData.shared.userId else { return nil }
        let filename = "\(uid).png"
        do {
            let url = try await Storage.storage().uploadData(for: filename, data: data, bucket: .photos)
            return url
        } catch {
            print("image upload error : ", error.localizedDescription)
            return nil
        }
    }
}
