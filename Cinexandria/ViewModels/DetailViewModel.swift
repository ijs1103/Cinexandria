//
//  DetailViewModel.swift
//  Cinexandria
//
//  Created by 이주상 on 2023/09/09.
//

import SwiftUI
import YouTubePlayerKit

final class DetailViewModel: ObservableObject {
    
    @Published var workDetail: WorkDetailViewModel? 
    @Published var reviews: [ReviewViewModel] = []
    @Published var imdbRating: String?
    @Published var youTubePlayer: YouTubePlayer?
    
    func load(media: MediaType, id: Int) {
        fetchWorkDetail(media: media, id: id)
        fetchReviews(media: media, id: id)
    }
    
    private func fetchWorkDetail(media: MediaType, id: Int) {
        if media == .movie {
            Webservice.shared.getMovieDetail(id: id) { result in
                switch result {
                case .success(let detail):
                    guard let detail = detail else { return }
                    DispatchQueue.main.async {
                        self.workDetail = WorkDetailViewModel(movie: detail, media: media)
                    }
                    self.fetchImdbRating(id: detail.imdbID)
                    self.configYoutube(id: detail.videos.results.last?.key)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            Task {
                do {
                    let detail = try await Webservice.shared.getTvDetail(id: id)
                    let tvCredits = try await Webservice.shared.getTvCredits(id: id)
                    DispatchQueue.main.async {
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
        Webservice.shared.getTvVideos(id: id) { result in
            switch result {
            case .success(let key):
                guard let key = key else { return }
                self.configYoutube(id: key)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configYoutube(id: String?) {
        guard let youtubeId = id else { return }
        DispatchQueue.main.async {
            self.youTubePlayer = YouTubePlayer(
                source: .video(id: youtubeId),
                configuration: .init()
            )
        }
    }
    
    private func fetchImdbRating(id: String) {
        Webservice.shared.getImdbRating(id: id) { result in
            switch result {
            case .success(let rating):
                guard let rating = rating else { return }
                DispatchQueue.main.async {
                    self.imdbRating = rating
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchReviews(media: MediaType, id: Int) {
        // get reviews by 작품 id
        // 초기 호출에는 최신 3개의 리뷰만 get, 더보기 페이지 들어갈때엔 모든 리뷰를 get
        self.reviews = [ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")) ]
    }
}
