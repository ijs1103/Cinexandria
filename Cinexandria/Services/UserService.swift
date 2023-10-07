//
//  UserService.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/02.
//

import FirebaseAuth
import FirebaseFirestore

enum FirebaseError: Error {
    case dataEmpty
}

struct UserService {
    static func setUser(data: [String: Any]) {
        guard let uid = Auth.auth().currentUser?.uid ?? data["uid"] as? String else { return }
        let db = Firestore.firestore().collection("users")
        Task {
            do {
                let isExisting = try await db.getDocuments().documents.map { $0.documentID}.contains(uid)
                if isExisting {
                    print("이미 가입된 id입니다")
                    return
                }
            } catch {
                print("firebase error - getDocuments")
                return
            }
            do {
                try await db.document(uid).setData(data)
            } catch {
                print("firebase error - setUser")
            }
        }
    }
    
    static func getUser(uid: String) async throws -> User {
        let db = Firestore.firestore().collection("users")
        let snapshot = try await db.document(uid).getDocument()
        guard let dictionary = snapshot.data() else { throw FirebaseError.dataEmpty }
        let user = User(dictionary: dictionary)
        return user
    }
    
    static func updateUser(uid: String, data: [String: Any]) async {
        let db = Firestore.firestore().collection("users")
        do {
            try await db.document(uid).updateData(data)
        } catch {
            print("firebase error - updateUser")
        }
    }
    
    static func likeWork(uid: String, workId: String, media: MediaType) {
        let db = Firestore.firestore().collection("users").document(uid)
        db.collection("likedWorks").document(workId).setData(["id": workId, "media": media.rawValue])
        // 좋아요 1 증가
        db.updateData([
            "likeCount": FieldValue.increment(Int64(1))
        ])
    }
    
    static func likeCancel(uid: String, workId: String) {
        let db = Firestore.firestore().collection("users").document(uid)
        db.collection("likedWorks").document(workId).delete()
        db.updateData([
            "likeCount": FieldValue.increment(Int64(-1))
        ])
    }
    
    static func likeCheck(uid: String, workId: String) async -> Bool {
        let db = Firestore.firestore().collection("users").document(uid)
        do {
            let likeSnapshot = try await db.collection("likedWorks").document(workId).getDocument()
            return likeSnapshot.exists
        } catch {
            print("firebase error - likeCheck")
            return false
        }
    }
    
    static func getLikedWorks(uid: String) async -> [String]? {
        let db = Firestore.firestore().collection("users").document(uid)
        do {
            let likedWorksRef = try await db.collection("likedWorks").getDocuments()
            return likedWorksRef.documents.map { $0.documentID }
        } catch {
            print("firebase error - likeCheck")
            return nil
        }
    }
}
