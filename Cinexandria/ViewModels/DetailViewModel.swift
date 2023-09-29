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
    @Published var imdbRating: String?
    @Published var youTubePlayer: YouTubePlayer?
    
    func load(media: MediaType, id: Int) async {
        await MainActor.run {
            clear()
        }
        await fetchWorkDetail(media: media, id: id)
        await fetchReviews(media: media, id: id)
    }
    
    private func clear() {
        workDetail = nil
        reviews = []
        imdbRating = nil
        youTubePlayer = nil
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
        await MainActor.run {
            self.youTubePlayer = YouTubePlayer(
                source: .video(id: youtubeId),
                configuration: .init()
            )
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
    
    private func fetchReviews(media: MediaType, id: Int) async {
        // get reviews by 작품 id
        // 초기 호출에는 최신 3개의 리뷰만 get, 더보기 페이지 들어갈때엔 모든 리뷰를 get
        await MainActor.run {
            self.reviews = [ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")), ReviewViewModel(review: Review(reviewerId: "1", reviewerName: "귀요미", reviewerAvatarString: "", workId: 1, workTitle: "스타워즈: 라스트 제다이", title: "흠잡을데 없는 완성도의 오락", rating: "4.5", text: "장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽 장자의 호접몽", createdAt: "1년전")) ]
        }
    }
}
