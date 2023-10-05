//
//  Storage+.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/06.
//

import Foundation
import FirebaseStorage

enum FirebaseStorageBuckets: String {
    case photos
    case attachments
}

extension Storage {
    
    func uploadData(for key: String, data: Data, bucket: FirebaseStorageBuckets) async throws -> URL {
        let storageRef = Storage.storage().reference()
        let photosRef = storageRef.child("\(bucket.rawValue)/\(key)")
        photosRef.putData(data)
        let downloadURL = try await photosRef.downloadURL()
        return downloadURL
    }
    
}
