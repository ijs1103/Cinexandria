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
                print("firebase error - setData")
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
}
