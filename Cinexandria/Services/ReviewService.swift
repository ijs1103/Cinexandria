//
//  ReviewService.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/10/09.
//

import Foundation
import FirebaseFirestore

struct ReviewService {
    static func setReview(data: [String: Any]) async {
        let workId = data["workId"] as! Int
        let uid = data["uid"] as! String
        let docId = "\(workId)\(uid)" // 복합키, documentPath로 사용
        let db = Firestore.firestore().collection("reviews")
        
        do {
            let isExistingReview = try await db.document(docId).getDocument().exists
            if isExistingReview {
                print("이미 작품에 대한 리뷰를 작성하였습니다.")
                return
            }
            try await db.document(docId).setData(data)
        } catch {
            print("firebase error - setReview")
            return
        }
    }
    
    static func updateReview(data: [String: Any]) async {
        let workId = data["workId"] as! Int
        let uid = data["uid"] as! String
        let docId = "\(workId)\(uid)"
        let db = Firestore.firestore().collection("reviews")
        do {
            try await db.document(docId).updateData(data)
        } catch {
            print("firebase error - updateReview")
            return
        }
    }
    
    static func deleteReview(uid: String, workId: Int) async {
        let docId = "\(workId)\(uid)"
        let db = Firestore.firestore().collection("reviews")
        do {
            try await db.document(docId).delete()
        } catch {
            print("firebase error - deleteReview")
            return
        }
    }
    
    static func getReviewsByWork(workId: Int, isAll: Bool) async -> [Review]? {
        let db = Firestore.firestore().collection("reviews").whereField("workId", isEqualTo: workId).order(by: "createdAt", descending: true)
        
        do {
            // .order(by: "createdAt", descending: true).limit(to: 3) , 최근에 작성된 3건의 리뷰
            let snapshot = isAll ? try await db.getDocuments() : try await db.limit(to: 3).getDocuments()
            return snapshot.documents.compactMap { decodeSnapshot(dict: $0.data()) }
        } catch {
            print("firebase error - getReviewsByWork")
            return nil
        }
    }
    
    static func getReviewCountByWork(workId: Int) async -> Int {
        let db = Firestore.firestore().collection("reviews").whereField("workId", isEqualTo: workId).order(by: "createdAt", descending: true)
        do {
            let snapshot = try await db.getDocuments()
            return snapshot.count
        } catch {
            print("firebase error - getReviewCountByWork")
            return 0
        }
    }
    
    static func getFirstRecentReviewsQuery() -> Query {
        // 최신 리뷰 4개
        let firstQuery = Firestore.firestore().collection("reviews").order(by: "createdAt", descending: true).limit(to: 4)
        return firstQuery
    }
    
    static func getNextRecentReviewsQuery(query: Query, completion: @escaping (Query?) -> Void) {
        query.addSnapshotListener { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error retreving recentReviews: \(error.debugDescription)")
                completion(nil)
                return
            }
            guard let lastSnapshot = snapshot.documents.last else {
                completion(nil)
                return
            }
            let nextQuery = Firestore.firestore().collection("reviews").order(by: "createdAt", descending: true).start(afterDocument: lastSnapshot)
            completion(nextQuery)
        }
    }
    
    static func convertReviewQueryToReviwVM(query: Query) async -> [ReviewViewModel]? {
        do {
            let snapshot = try await query.getDocuments()
            return snapshot.documents.compactMap { decodeSnapshot(dict: $0.data()) }.compactMap{ ReviewViewModel(review: $0) }
        } catch {
            print("decode error - convertReviewQueryToReviwVM")
            return nil
        }
    }
    
    static func getMyReviewAndCount() async -> (reviews: [ReviewViewModel], count: Int)? {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - getMyReviewAndCount")
            return nil
        }
        let db = Firestore.firestore().collection("reviews").whereField("uid", isEqualTo: uid).order(by: "createdAt", descending: true)
        do {
            let snapshot = try await db.getDocuments()
            let reviews = snapshot.documents.compactMap { decodeSnapshot(dict: $0.data()) }.compactMap{ ReviewViewModel(review: $0) }
            return (reviews: reviews, count: snapshot.count)
        } catch {
            print("firebase error - getMyReviewAndCount")
            return nil
        }
    }
    
    static func getMyReview(workId: Int, uid: String) async -> ReviewViewModel? {
        let docId = "\(workId)\(uid)"
        let db = Firestore.firestore().collection("reviews").document(docId)
        do {
            let snapshot = try await db.getDocument()
            if let data = snapshot.data() {
                if let decoded = decodeSnapshot(dict: data) {
                    let myReview = ReviewViewModel(review: decoded)
                    return myReview
                }
            } else {
                return nil
            }
        } catch {
            print("firebase error - getMyReview")
            return nil
        }
        return nil
    }
    
    static func decodeSnapshot(dict: [String: Any]) -> Review? {
        guard let id = dict["id"] as? String,
              let uid = dict["uid"] as? String,
              let mediaType = MediaType(rawValue: (dict["mediaType"] as! String)),
              let nickname = dict["nickname"] as? String,
              let avatarURL = dict["avatarURL"] as? String,
              let posterURL = dict["posterURL"] as? String,
              let title = dict["title"] as? String,
              let rating = dict["rating"] as? Int,
              let workId = dict["workId"] as? Int,
              let workTitle = dict["workTitle"] as? String,
              let text = dict["text"] as? String,
              let createdAt = (dict["createdAt"] as? Timestamp)?.dateValue()
        else { return nil }
        
        return Review(id: id, uid: uid, workId: workId, mediaType: mediaType, nickname: nickname, avatarURL: avatarURL, posterURL: posterURL, rating: rating, workTitle: workTitle, title: title, text: text, createdAt: createdAt)
    }
}
