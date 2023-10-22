//
//  DetailViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/09.
//

import SwiftUI
import YouTubePlayerKit

final class DetailViewModel: ObservableObject {
    static let shared = DetailViewModel()
    private init() {}
    
    @Published var workDetail: WorkDetailViewModel?
    @Published var reviews: [ReviewViewModel] = []
    @Published var reviewCount: Int = 0
    @Published var imdbRating: String?
    @Published var videoSource: YouTubePlayer.Source?
    @Published var isLiked: Bool = false
    @Published var isLoggined: Bool = false
    @Published var myReview: ReviewViewModel?
    
    func load(media: MediaType, id: Int) async {
        await clear()
        await fetchWorkDetail(media: media, id: id)
        await fetchReviews(id: id)
        await fetchReviewCount(id: id)
        await likeCheck(id: id)
        await reviewCheck(id: id)
        await loginCheck()
    }
    
    private func clear() async  {
        DispatchQueue.main.async {
            self.workDetail = nil
            self.reviews = []
            self.imdbRating = nil
            self.videoSource = nil
        }
    }
    
    private func fetchWorkDetail(media: MediaType, id: Int) async {
        
        if media == .movie {
            Task {
                do {
                    let detail = try await Webservice.shared.getMovieDetail(id: id)
                    DispatchQueue.main.async {
                        self.workDetail = WorkDetailViewModel(movie: detail, media: media)
                    }
                    if let imdbId = detail.imdbID {
                        self.fetchImdbRating(id: imdbId)
                    }
                    if let videos = detail.videos {
                        await self.configYoutube(id: videos.results.last?.key)
                    }

                } catch NetworkError.badDecoding {
                    print("movie error - badDecoding")
                } catch NetworkError.badServer {
                    print("movie error - badServer")
                }
            }
            
            
        } else {
            Task {
                do {
                    let detail = try await Webservice.shared.getTvDetail(id: id)
                    let tvCredits = try await Webservice.shared.getTvCredits(id: id)
                    await MainActor.run {
                        self.workDetail = WorkDetailViewModel(tv: detail, media: media)
                        self.workDetail?.setTvCredits(credits: tvCredits)
                    }
                    self.fetchTvVideos(id: id)
                } catch NetworkError.badDecoding {
                    print("tv error - badDecoding")
                } catch NetworkError.badServer {
                    print("tv error - badServer")
                }
            }
        }
        
    }
    
    private func fetchTvVideos(id: Int) {
        Task {
            do {
                let youtubeKey = try await Webservice.shared.getTvVideos(id: id)
                await self.configYoutube(id: youtubeKey)
            } catch NetworkError.badDecoding {
                print("tv error - badDecoding")
            } catch NetworkError.badServer {
                print("tv error - badServer")
            }
        }
    }
    
    private func configYoutube(id: String?) async {
        guard let youtubeId = id else { return }
        DispatchQueue.main.async {
            self.videoSource = .video(id: youtubeId)
        }
    }
    
    private func fetchImdbRating(id: String) {
        Task {
            do {
                let rating = try await Webservice.shared.getImdbRating(id: id)
                await MainActor.run {
                    self.imdbRating = rating
                }
            } catch NetworkError.badDecoding {
                print("imdb error - badDecoding")
            } catch NetworkError.badServer {
                print("imdb error - badServer")
            }
        }
    }
    
    func fetchReviews(id: Int, isAll: Bool = false) async {
        // 초기 호출에는 최신 3개의 리뷰만 get, 더보기 페이지 들어갈때엔 모든 리뷰를 get
        guard let response = await ReviewService.getReviewsByWork(workId: id, isAll: isAll) else {
            return
        }
        let reviews = response.map { ReviewViewModel(review: $0) }
        DispatchQueue.main.async {
            self.reviews = reviews
        }
    }
    
    func fetchReviewCount(id: Int) async {
        let reviewCount = await ReviewService.getReviewCountByWork(workId: id)
        DispatchQueue.main.async {
            self.reviewCount = reviewCount
        }
    }
    
    func likeWork() async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - likeWork")
            return
        }
        guard let workDetail = workDetail else {
            print("no data - likeWork")
            return
        }
        UserService.likeWork(uid: uid, work: workDetail)
        await MainActor.run {
            self.isLiked = true
        }
    }
    
    func likeCancel() async {
        guard let uid = LocalData.shared.userId, let workId = workDetail?.id else {
            print("no authorization - likeCancel")
            return
        }
        UserService.likeCancel(uid: uid, workId: String(workId))
        await MainActor.run {
            self.isLiked = false
        }
    }
    
    func likeCheck(id: Int) async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - likeCheck")
            return
        }
        let isLiked = await UserService.likeCheck(uid: uid, workId: String(id))
        DispatchQueue.main.async {
            self.isLiked = isLiked
        }
    }
    
    func loginCheck() async {
        DispatchQueue.main.async {
            self.isLoggined = (LocalData.shared.userId != nil)
        }
    }
    
    func reviewCheck(id: Int) async {
        guard let uid = LocalData.shared.userId else {
            print("no authorization - reviewCheck")
            return
        }
        if let myReview = await ReviewService.getMyReview(workId: id, uid: uid) {
            DispatchQueue.main.async {
                self.myReview = myReview
            }
        } else {
            DispatchQueue.main.async {
                self.myReview = nil
            }
        }
    }
}
