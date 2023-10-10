//
//  ReviewService.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import Foundation
import FirebaseFirestore

struct ReviewService {
    static func setReview(uid: String, workId: Int, data: [String: Any]) async {
        let db = Firestore.firestore().collection("review").document(String(workId)).collection("reviews")
        do {
            let isExisting = try await db.getDocuments().documents.map { $0.documentID}.contains(uid)
            if isExisting {
                print("이미 작품에 대한 리뷰를 작성하였습니다.")
                return
            }
            try await db.document(uid).setData(data)
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
    
    static func getReviewsByWork(workId: Int, isAll: Bool) async -> [Review]? {
        let db = Firestore.firestore().collection("review").document(String(workId))
        do {
            // .order(by: "createdAt").limit(to: 3) , 최근에 작성된 3건의 리뷰
            let snapshot = isAll ? try await db.collection("reviews").order(by: "createdAt", descending: true).getDocuments() : try await db.collection("reviews").order(by: "createdAt", descending: true).limit(to: 3).getDocuments()
            return snapshot.documents.compactMap { decodeSnapshot(dict: $0.data()) }
        } catch {
            print("firebase error - getReviews")
            return nil
        }
    }
    
    static func getReviewCountByWork(workId: Int) async -> Int {
        let db = Firestore.firestore().collection("review").document(String(workId)).collection("reviews")
        do {
            let snapshot = try await db.getDocuments()
            return snapshot.count
        } catch {
            print("firebase error - getReviewCountByWork")
            return 0
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
    
    static func decodeSnapshot(dict: [String: Any]) -> Review? {
        guard let id = dict["id"] as? String,
              let mediaType = MediaType(rawValue: (dict["mediaType"] as! String)),
              let nickname = dict["nickname"] as? String,
              let photoURL = dict["photoURL"] as? String,
              let title = dict["title"] as? String,
              let rating = dict["rating"] as? Int,
              let workId = dict["workId"] as? Int,
              let workTitle = dict["workTitle"] as? String,
              let text = dict["text"] as? String,
              let createdAt = (dict["createdAt"] as? Timestamp)?.dateValue()
        else { return nil }
        
        return Review(id: id, workId: workId, mediaType: mediaType, nickname: nickname, photoURL: photoURL, rating: rating, workTitle: workTitle, title: title, text: text, createdAt: createdAt)
    }
}
