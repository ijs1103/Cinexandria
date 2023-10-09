//
//  ReviewService.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import Foundation
import FirebaseFirestore

struct ReviewService {
    static func setReview(uid: String, workId: String, data: [String: Any]) async {
        let db = Firestore.firestore().collection("review").document(workId).collection("reviews")
        do {
            let isExisting = try await db.getDocuments().documents.map { $0.documentID}.contains(uid)
            if isExisting {
                print("이미 작품에 대한 리뷰를 작성하였습니다.")
                return
            }
            try await db.document(data["uid"] as! String).setData(data)
        } catch {
            print("firebase error - setReview")
            return
        }
    }
    
    static func deleteReview(uid: String, workId: String) {
        let db = Firestore.firestore().collection("review").document(workId)
        db.collection("reviews").document(uid).delete()
        db.updateData([
            "reviewCount": FieldValue.increment(Int64(-1))
        ])
    }
    
    static func getReviewsByWork(workId: String) async -> [[String : Any]]? {
        let db = Firestore.firestore().collection("review").document(workId)
        do {
            let snapshot = try await db.collection("reviews").getDocuments()
            return snapshot.documents.map { $0.data() }
        } catch {
            print("firebase error - getReviews")
            return nil
        }
    }
    
    static func getAllReviews() async -> [[String : Any]]? {
        let db = Firestore.firestore().collection("review")
        do {
            let snapshot = try await db.getDocuments()
            return snapshot.documents.map { $0.data() }
        } catch {
            print("firebase error - getAllReviews")
            return nil
        }
    }
    
    static func getReviewCount(workId: String) async -> Int {
        let db = Firestore.firestore().collection("review").document(workId)
        do {
            guard let data = try await db.getDocument().data() else { return 0 }
            if let likeCount = data["likeCount"] as? Int {
                return likeCount
            } else {
                return 0
            }
        } catch {
            print("firebase error - getReviewCount")
            return 0
        }
    }
}
